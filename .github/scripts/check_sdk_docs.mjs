// Checks an sdk-docs/ folder before it lands on irkit-releases (iOS on main, Android on gh-pages), where the Developer Portal publishes it.
//
//   node check_sdk_docs.mjs <sdk-docs> [version]
//
// - index.md, _nav.yaml and CHANGELOG.md are present, and every folder _nav.yaml names exists
// - every page has front matter with a title and a one-line description
// - every relative link and image resolves, including #anchors into another page's headings
// - no page links to docs.ircode.app, which redirects to the portal
// - with a version, CHANGELOG.md has a "## [<version>]" entry
//
// Prints each problem and exits 1 if there are any.
import { existsSync, readdirSync, readFileSync, statSync } from 'node:fs';
import { dirname, join, relative, resolve } from 'node:path';

const [root, version] = process.argv.slice(2);
if (!root || !existsSync(root)) {
    console.error('usage: node check_sdk_docs.mjs <sdk-docs> [version]');
    process.exit(2);
}

const problems = [];
const problem = (file, message) => problems.push(`${file}: ${message}`);

const walk = dir => readdirSync(dir).flatMap(name => {
    const path = join(dir, name);
    return statSync(path).isDirectory() ? walk(path) : [path];
});
const pages = walk(root).filter(path => path.endsWith('.md'));

for (const required of ['index.md', '_nav.yaml', 'CHANGELOG.md']) {
    if (!existsSync(join(root, required))) problem(required, 'missing');
}
if (existsSync(join(root, '_nav.yaml'))) {
    for (const [, folder] of readFileSync(join(root, '_nav.yaml'), 'utf8').matchAll(/^\s*-?\s*folder:\s*(\S+)/gm)) {
        if (!existsSync(join(root, folder))) problem('_nav.yaml', `names folder ${folder}/, which does not exist`);
    }
}

// The portal's heading ids (github-slugger): lowercase, punctuation other than - and _ dropped, spaces as -,
// and a repeated heading gets -1, -2
const anchorsOf = new Map();
const anchors = file => {
    if (!anchorsOf.has(file)) {
        const seen = new Map();
        const ids = new Set();
        const text = readFileSync(file, 'utf8').replace(/^```[\s\S]*?^```/gm, '');
        for (const [, heading] of text.matchAll(/^#{1,6}\s+(.+?)\s*#*\s*$/gm)) {
            const base = heading
                .replace(/\[([^\]]*)\]\([^)]*\)/g, '$1')
                .replace(/[`*]/g, '')
                .toLowerCase()
                .replace(/[^a-z0-9 _-]/g, '')
                .replace(/ /g, '-');
            const count = seen.get(base) ?? 0;
            seen.set(base, count + 1);
            ids.add(count ? `${base}-${count}` : base);
        }
        anchorsOf.set(file, ids);
    }
    return anchorsOf.get(file);
};

for (const file of pages) {
    const name = relative(root, file);
    const text = readFileSync(file, 'utf8');

    if (name !== 'CHANGELOG.md') {
        const front = text.match(/^---\n([\s\S]*?)\n---\n/);
        if (!front) problem(name, 'no front matter');
        else {
            for (const key of ['title', 'description']) {
                const value = front[1].match(new RegExp(`^${key}:\\s*(.*)$`, 'm'))?.[1]?.replace(/^"|"$/g, '').trim();
                if (!value) problem(name, `front matter has no ${key}`);
            }
        }
    }

    if (/docs\.ircode\.app/.test(text)) problem(name, 'links to docs.ircode.app; link to the page in sdk-docs/ instead');

    const prose = text.replace(/^```[\s\S]*?^```/gm, '').replace(/`[^`\n]*`/g, match => (match.includes('](') ? match : ''));
    for (const [, target] of prose.matchAll(/!?\[[^\]]*\]\(([^)\s]+)(?:\s+"[^"]*")?\)/g)) {
        if (/^[a-z][a-z0-9+.-]*:/i.test(target)) continue;
        const [path, anchor] = target.split('#');
        const destination = path ? resolve(dirname(file), decodeURIComponent(path)) : file;
        if (path && !destination.startsWith(resolve(root))) {
            problem(name, `links outside sdk-docs/: ${target}`);
            continue;
        }
        if (!existsSync(destination)) {
            problem(name, `broken link: ${target}`);
            continue;
        }
        if (anchor && destination.endsWith('.md') && !anchors(destination).has(anchor)) {
            problem(name, `no heading for anchor: ${target}`);
        }
    }
}

if (version && existsSync(join(root, 'CHANGELOG.md'))) {
    const escaped = version.replace(/\./g, '\\.');
    if (!new RegExp(`^## \\[${escaped}\\]`, 'm').test(readFileSync(join(root, 'CHANGELOG.md'), 'utf8'))) {
        problem('CHANGELOG.md', `no "## [${version}]" entry`);
    }
}

if (problems.length) {
    console.error(problems.join('\n'));
    console.error(`\n${problems.length} problem${problems.length === 1 ? '' : 's'} in ${root}`);
    process.exit(1);
}
console.log(`${pages.length} pages OK${version ? `, CHANGELOG has ${version}` : ''}`);
