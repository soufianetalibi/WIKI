#!/bin/bash

# Script de configuration automatique du projet IoT Dashboard pour Azure Static Web Apps
# Usage: ./setup-project.sh

set -e

echo "🚀 Configuration du projet IoT Dashboard"
echo "========================================"
echo ""

# Couleurs pour l'affichage
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Vérifier si Node.js est installé
if ! command -v node &> /dev/null; then
    echo "❌ Node.js n'est pas installé. Veuillez l'installer depuis https://nodejs.org/"
    exit 1
fi

echo -e "${GREEN}✓${NC} Node.js version: $(node --version)"
echo -e "${GREEN}✓${NC} npm version: $(npm --version)"
echo ""

# Créer la structure du projet
echo -e "${BLUE}📁 Création de la structure du projet...${NC}"

mkdir -p iot-dashboard
cd iot-dashboard

# Créer les dossiers
mkdir -p src public

# Créer package.json
echo -e "${BLUE}📦 Création de package.json...${NC}"
cat > package.json << 'EOF'
{
  "name": "iot-dashboard",
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "tsc && vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "recharts": "^2.10.0",
    "lucide-react": "^0.263.1"
  },
  "devDependencies": {
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0",
    "@vitejs/plugin-react": "^4.2.0",
    "autoprefixer": "^10.4.16",
    "postcss": "^8.4.32",
    "tailwindcss": "^3.4.0",
    "typescript": "^5.3.0",
    "vite": "^5.0.0"
  }
}
EOF

# Créer vite.config.ts
echo -e "${BLUE}⚙️  Création de vite.config.ts...${NC}"
cat > vite.config.ts << 'EOF'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  base: '/',
})
EOF

# Créer tsconfig.json
echo -e "${BLUE}⚙️  Création de tsconfig.json...${NC}"
cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "useDefineForClassFields": true,
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx",
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true
  },
  "include": ["src"],
  "references": [{ "path": "./tsconfig.node.json" }]
}
EOF

# Créer tsconfig.node.json
cat > tsconfig.node.json << 'EOF'
{
  "compilerOptions": {
    "composite": true,
    "skipLibCheck": true,
    "module": "ESNext",
    "moduleResolution": "bundler",
    "allowSyntheticDefaultImports": true
  },
  "include": ["vite.config.ts"]
}
EOF

# Créer tailwind.config.js
echo -e "${BLUE}🎨 Création de tailwind.config.js...${NC}"
cat > tailwind.config.js << 'EOF'
/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOF

# Créer postcss.config.js
cat > postcss.config.js << 'EOF'
export default {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
EOF

# Créer index.html
echo -e "${BLUE}📄 Création de index.html...${NC}"
cat > index.html << 'EOF'
<!doctype html>
<html lang="fr">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>IoT Hub Dashboard</title>
    <meta name="description" content="Dashboard de monitoring IoT en temps réel">
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
EOF

# Créer src/index.css
echo -e "${BLUE}🎨 Création de src/index.css...${NC}"
cat > src/index.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen',
    'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue',
    sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
EOF

# Créer src/main.tsx
echo -e "${BLUE}⚛️  Création de src/main.tsx...${NC}"
cat > src/main.tsx << 'EOF'
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.tsx'
import './index.css'

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
)
EOF

# Créer .gitignore
echo -e "${BLUE}📝 Création de .gitignore...${NC}"
cat > .gitignore << 'EOF'
# Dependencies
node_modules/
package-lock.json
yarn.lock

# Production
dist/
build/

# Local
.env
.env.local
.DS_Store

# IDE
.vscode/
.idea/
*.swp
*.swo

# Logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Testing
coverage/
.nyc_output/

# Misc
.cache/
EOF

# Créer staticwebapp.config.json
echo -e "${BLUE}⚙️  Création de staticwebapp.config.json...${NC}"
cat > staticwebapp.config.json << 'EOF'
{
  "navigationFallback": {
    "rewrite": "/index.html"
  },
  "responseOverrides": {
    "404": {
      "rewrite": "/index.html"
    }
  },
  "globalHeaders": {
    "content-security-policy": "default-src 'self' 'unsafe-inline' https://cdnjs.cloudflare.com"
  }
}
EOF

# Créer README.md
echo -e "${BLUE}📖 Création de README.md...${NC}"
cat > README.md << 'EOF'
# IoT Dashboard

Dashboard de monitoring en temps réel pour capteurs IoT connectés à Azure IoT Hub.

## 🚀 Démarrage rapide

```bash
# Installer les dépendances
npm install

# Lancer en mode développement
npm run dev

# Builder pour production
npm run build
```

## 📦 Technologies utilisées

- React 18
- TypeScript
- Vite
- Tailwind CSS
- Recharts
- Lucide React

## 🌐 Déploiement sur Azure

Ce projet est configuré pour être déployé sur Azure Static Web Apps.

### Prérequis
- Compte Azure
- Repository GitHub

### Étapes
1. Poussez le code sur GitHub
2. Créez une Static Web App dans le portail Azure
3. Connectez votre repository GitHub
4. Azure déploiera automatiquement votre application

## 📝 Configuration

- **App location**: `/`
- **Output location**: `dist`
- **Build preset**: React

## 📄 Licence

MIT
EOF

echo ""
echo -e "${GREEN}✓${NC} Structure du projet créée avec succès !"
echo ""

# Message pour copier le fichier App.tsx
echo -e "${YELLOW}⚠️  ACTION REQUISE:${NC}"
echo "Copiez maintenant votre fichier ${BLUE}iot_hub_dashboard.tsx${NC} dans ${BLUE}src/App.tsx${NC}"
echo ""
echo "Commande:"
echo -e "${BLUE}cp /chemin/vers/iot_hub_dashboard.tsx src/App.tsx${NC}"
echo ""

# Installation des dépendances
read -p "Voulez-vous installer les dépendances npm maintenant ? (o/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[OoYy]$ ]]
then
    echo -e "${BLUE}📦 Installation des dépendances...${NC}"
    npm install
    echo -e "${GREEN}✓${NC} Dépendances installées !"
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}✓ Configuration terminée !${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Prochaines étapes:"
echo "1. Copiez votre fichier iot_hub_dashboard.tsx dans src/App.tsx"
echo "2. Testez localement: ${BLUE}npm run dev${NC}"
echo "3. Créez un repo GitHub et poussez le code"
echo "4. Déployez sur Azure Static Web Apps"
echo ""
echo "Pour démarrer le serveur de développement:"
echo -e "${BLUE}cd iot-dashboard && npm run dev${NC}"
echo ""