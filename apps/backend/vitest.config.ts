/* eslint-disable @typescript-eslint/naming-convention */
import { resolve } from 'path'
import swc from 'unplugin-swc'
import { defineConfig } from 'vitest/config'

export default defineConfig({
  test: {
    include: ['**/*.spec.ts'],
    globals: true,
    root: './',
    coverage: {
      provider: 'v8',
      include: ['**/*.service.ts']
    }
  },
  resolve: {
    alias: {
      '@': resolve(__dirname, './src')
    }
  },
  plugins: [swc.vite()]
})
