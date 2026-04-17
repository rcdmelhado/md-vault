#!/bin/bash

# MD Vault Sync & Deploy Script
# Uso: ./vault-sync.sh [message]
# Ou: ./vault-sync.sh --auto (sincroniza com timestamp automático)

set -e

VAULT_DIR="$HOME/md-vault"
PAGES_DIR="$HOME/md-vault-pages"
REPO="rcdmelhado/md-vault"

# Cores pra output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== MD Vault Sync & Deploy ===${NC}\n"

# 1. Sync vault (master branch)
echo -e "${YELLOW}📝 Sincronizando vault...${NC}"
cd "$VAULT_DIR"

# Verifica se tem mudanças
if git status --porcelain | grep -q .; then
    # Define commit message
    if [ "$1" == "--auto" ]; then
        MESSAGE="Auto-sync: $(date '+%Y-%m-%d %H:%M:%S')"
    elif [ -n "$1" ]; then
        MESSAGE="$1"
    else
        MESSAGE="Update: $(date '+%Y-%m-%d %H:%M:%S')"
    fi

    git add -A
    git commit -m "$MESSAGE"
    git push origin master
    echo -e "${GREEN}✓ Vault sincronizado${NC}\n"
else
    echo -e "${YELLOW}ℹ Nenhuma mudança no vault${NC}\n"
fi

# 2. Gerar site estático (GitHub Pages)
echo -e "${YELLOW}🔨 Gerando site estático...${NC}"

# Remove pasta anterior
rm -rf "$PAGES_DIR"
mkdir -p "$PAGES_DIR"

# Cria index.html com URLs absolutas
cat > "$PAGES_DIR/index.html" << 'HTMLEOF'
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MD Vault - Ricardo Melhado</title>
    <script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/dompurify/dist/purify.min.js"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background: #0d1117;
            color: #c9d1d9;
            line-height: 1.6;
        }
        .container {
            display: flex;
            height: 100vh;
        }
        .sidebar {
            width: 280px;
            background: #161b22;
            border-right: 1px solid #30363d;
            overflow-y: auto;
            padding: 20px;
        }
        .content {
            flex: 1;
            overflow-y: auto;
            padding: 40px;
        }
        .header {
            margin-bottom: 30px;
            border-bottom: 1px solid #30363d;
            padding-bottom: 20px;
        }
        .header h1 {
            font-size: 24px;
            margin-bottom: 5px;
        }
        .header p {
            font-size: 13px;
            color: #8b949e;
        }
        .category {
            margin-bottom: 25px;
        }
        .category-title {
            font-size: 12px;
            font-weight: 600;
            color: #8b949e;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 10px;
        }
        .file-list {
            list-style: none;
        }
        .file-item {
            margin-bottom: 8px;
        }
        .file-item a {
            display: block;
            padding: 8px 12px;
            border-radius: 6px;
            color: #58a6ff;
            text-decoration: none;
            font-size: 13px;
            transition: background 0.2s;
            cursor: pointer;
        }
        .file-item a:hover {
            background: #30363d;
            color: #79c0ff;
        }
        .file-item a.active {
            background: #1f6feb;
            color: #fff;
        }
        .markdown-content {
            background: #0d1117;
            max-width: 900px;
        }
        .markdown-content h1,
        .markdown-content h2,
        .markdown-content h3,
        .markdown-content h4,
        .markdown-content h5,
        .markdown-content h6 {
            margin-top: 24px;
            margin-bottom: 16px;
            font-weight: 600;
            line-height: 1.25;
        }
        .markdown-content h1 { font-size: 2em; border-bottom: 1px solid #30363d; padding-bottom: 10px; }
        .markdown-content h2 { font-size: 1.5em; }
        .markdown-content h3 { font-size: 1.25em; }
        .markdown-content p {
            margin-bottom: 16px;
        }
        .markdown-content code {
            background: #161b22;
            padding: 2px 6px;
            border-radius: 3px;
            font-family: 'Courier New', monospace;
            font-size: 0.9em;
        }
        .markdown-content pre {
            background: #161b22;
            padding: 16px;
            border-radius: 6px;
            overflow-x: auto;
            margin-bottom: 16px;
        }
        .markdown-content pre code {
            background: none;
            padding: 0;
        }
        .markdown-content blockquote {
            border-left: 3px solid #30363d;
            padding-left: 12px;
            color: #8b949e;
            margin-bottom: 16px;
        }
        .markdown-content ul,
        .markdown-content ol {
            margin-left: 20px;
            margin-bottom: 16px;
        }
        .markdown-content li {
            margin-bottom: 8px;
        }
        .markdown-content table {
            border-collapse: collapse;
            width: 100%;
            margin-bottom: 16px;
        }
        .markdown-content table tr {
            border-bottom: 1px solid #30363d;
        }
        .markdown-content table td,
        .markdown-content table th {
            padding: 12px;
            text-align: left;
        }
        .markdown-content table th {
            font-weight: 600;
            background: #161b22;
        }
        .welcome {
            color: #8b949e;
            font-style: italic;
        }
        .error {
            color: #f85149;
            padding: 20px;
            background: #161b22;
            border-radius: 6px;
        }
        @media (max-width: 768px) {
            .container {
                flex-direction: column;
            }
            .sidebar {
                width: 100%;
                border-right: none;
                border-bottom: 1px solid #30363d;
                max-height: 200px;
            }
            .content {
                padding: 20px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="sidebar">
            <div class="header">
                <h1>MD Vault</h1>
                <p>Ricardo Melhado</p>
            </div>
            <div id="sidebar-content">
                <p style="color: #8b949e; font-size: 12px;">Carregando...</p>
            </div>
        </div>
        <div class="content">
            <div id="content" class="markdown-content">
                <div class="welcome">
                    <p>👋 Carregando arquivos...</p>
                </div>
            </div>
        </div>
    </div>

    <script>
        let files = {};
        let categories = {};
        let baseUrl = window.location.pathname.replace(/\/$/, '');

        async function loadFileStructure() {
            try {
                const url = window.location.origin + baseUrl + '/files.json';
                console.log('Carregando:', url);
                const response = await fetch(url);
                if (!response.ok) throw new Error('HTTP ' + response.status);
                const data = await response.json();
                console.log('Dados carregados:', data);
                files = data.files;
                categories = data.categories;
                renderSidebar();
            } catch (error) {
                console.error('Erro ao carregar estrutura:', error);
                document.getElementById('sidebar-content').innerHTML = '<div class="error">❌ Erro ao carregar arquivos</div>';
            }
        }

        function renderSidebar() {
            const sidebar = document.getElementById('sidebar-content');
            sidebar.innerHTML = '';

            for (const category in categories) {
                const div = document.createElement('div');
                div.className = 'category';
                div.innerHTML = `<div class="category-title">${category}</div><ul class="file-list"></ul>`;

                const list = div.querySelector('.file-list');
                categories[category].forEach(file => {
                    const li = document.createElement('li');
                    li.className = 'file-item';
                    const link = document.createElement('a');
                    link.textContent = file.name;
                    link.onclick = (e) => {
                        e.preventDefault();
                        loadFile(file.path, e.currentTarget);
                    };
                    li.appendChild(link);
                    list.appendChild(li);
                });

                sidebar.appendChild(div);
            }
        }

        async function loadFile(path, linkEl) {
            try {
                const url = window.location.origin + baseUrl + '/content/' + path;
                console.log('Carregando arquivo:', url);
                const response = await fetch(url);
                if (!response.ok) throw new Error('HTTP ' + response.status);
                const content = await response.text();
                const html = marked.parse(content);
                document.getElementById('content').innerHTML = DOMPurify.sanitize(html);

                document.querySelectorAll('.file-item a').forEach(a => a.classList.remove('active'));
                if (linkEl) linkEl.classList.add('active');
            } catch (error) {
                console.error('Erro ao carregar arquivo:', error);
                document.getElementById('content').innerHTML = '<div class="error">❌ Erro ao carregar arquivo</div>';
            }
        }

        loadFileStructure();
    </script>
</body>
</html>
HTMLEOF

# Cria structure JSON
echo "Gerando estrutura de arquivos..."
cat > "$PAGES_DIR/files.json" << 'JSONEOF'
{
  "files": [],
  "categories": {}
}
JSONEOF

# Copia arquivos markdown
mkdir -p "$PAGES_DIR/content"
cp -r "$VAULT_DIR"/* "$PAGES_DIR/content/" 2>/dev/null || true

# Remove .git se houver
rm -rf "$PAGES_DIR/content/.git"
rm -f "$PAGES_DIR/content/.gitignore"

# Gera JSON com lista de arquivos
python3 << 'PYSCRIPT'
import json
import os
from pathlib import Path

pages_dir = os.path.expanduser('~/md-vault-pages')
content_dir = os.path.join(pages_dir, 'content')

files = []
categories = {}

if os.path.exists(content_dir):
    for root, dirs, filenames in os.walk(content_dir):
        # Pula .git e outros ocultos
        dirs[:] = [d for d in dirs if not d.startswith('.')]
        
        for filename in filenames:
            if filename.endswith('.md') and not filename.startswith('.'):
                full_path = os.path.join(root, filename)
                rel_path = os.path.relpath(full_path, content_dir)
                
                # Extrai categoria da primeira pasta
                parts = rel_path.split('/')
                if len(parts) > 1:
                    category = parts[0].replace('-', ' ').title()
                else:
                    category = 'Root'
                
                if category not in categories:
                    categories[category] = []
                
                file_obj = {
                    'name': filename.replace('.md', ''),
                    'path': rel_path
                }
                files.append(file_obj)
                categories[category].append(file_obj)

# Ordena categorias
categories = dict(sorted(categories.items()))

structure = {
    'files': files,
    'categories': categories
}

with open(os.path.join(pages_dir, 'files.json'), 'w') as f:
    json.dump(structure, f, indent=2, ensure_ascii=False)

print(f"✓ {len(files)} arquivos processados")
PYSCRIPT

echo -e "${GREEN}✓ Site estático gerado${NC}\n"

# 3. Deploy Pages
echo -e "${YELLOW}🚀 Deployando GitHub Pages...${NC}"

cd "$PAGES_DIR"
git init
git config user.email "rcdmelhado@hotmail.com"
git config user.name "Ricardo Melhado"
git add .
git commit -m "Deploy: $(date '+%Y-%m-%d %H:%M:%S')"
git branch -M gh-pages
git remote add origin "git@github-personal:$REPO.git" 2>/dev/null || git remote set-url origin "git@github-personal:$REPO.git"
git push -f origin gh-pages

echo -e "${GREEN}✓ Deploy realizado${NC}\n"

# Summary
echo -e "${GREEN}=== ✓ Sucesso ===${NC}"
echo -e "📚 Vault local: $VAULT_DIR"
echo -e "🌐 GitHub Pages: https://rcdmelhado.github.io/md-vault/"
echo -e "\n${YELLOW}Próxima vez, execute:${NC}"
echo -e "  ./vault-sync.sh --auto"
echo -e "  ou"
echo -e "  ./vault-sync.sh 'Sua mensagem de commit'"
