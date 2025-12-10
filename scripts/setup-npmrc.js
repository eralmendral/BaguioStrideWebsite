#!/usr/bin/env node

/**
 * Setup .npmrc file for HugeIcons Pro authentication
 * This script is used during Vercel builds to create .npmrc from environment variables
 */

import { writeFileSync } from 'fs';
import { join } from 'path';

const HUGEICONS_LICENSE_KEY = process.env.HUGEICONS_LICENSE_KEY;

if (!HUGEICONS_LICENSE_KEY) {
  console.error('❌ HUGEICONS_LICENSE_KEY environment variable is not set');
  process.exit(1);
}

const npmrcContent = `# HugeIcons Pro Authentication
# This file is auto-generated during build
# Do not commit this file - it contains your license key

@hugeicons-pro:registry=https://npm.hugeicons.com/
//npm.hugeicons.com/:_authToken=${HUGEICONS_LICENSE_KEY}
`;

const npmrcPath = join(process.cwd(), '.npmrc');

try {
  writeFileSync(npmrcPath, npmrcContent, 'utf8');
  console.log('✅ .npmrc file created successfully');
} catch (error) {
  console.error('❌ Failed to create .npmrc file:', error);
  process.exit(1);
}

