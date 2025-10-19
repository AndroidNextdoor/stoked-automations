# Vercel Deployment Guide

This guide explains how the Stoked Automations marketplace is deployed to Vercel.

## Overview

The marketplace (Astro website) is **automatically deployed to Vercel** via Git integration. Every push to the repository triggers an automatic deployment. The live site is available at https://stokedautomations.com.

## Deployment Architecture

```
GitHub Repository
    ↓
Vercel Git Integration (automatic)
    ↓
Vercel Build & Deploy
    ↓
Production (stokedautomations.com)
```

**No GitHub Actions required!** Vercel's Git integration handles everything automatically.

## How It Works

### Automatic Deployment Triggers

| Branch | Deployment Type | URL |
|--------|----------------|-----|
| `main` | Production | https://stokedautomations.com |
| Feature branches | Preview | `https://marketplace-[hash].vercel.app` |
| Pull requests | Preview | Automatic preview comment on PR |

### Deployment Process

1. **Push to GitHub** (any branch)
2. **Vercel detects change** via webhook
3. **Builds project** using `vercel.json` configuration
4. **Deploys automatically:**
   - `main` branch → Production domain
   - Other branches → Preview URLs
5. **Comments on PR** with preview link (if applicable)

### No Secrets Required

Because Vercel uses **Git integration**, there's no need for:
- ❌ GitHub Actions workflows
- ❌ `VERCEL_TOKEN` secrets
- ❌ Manual CLI deployments

Everything happens automatically through Vercel's dashboard connection.

## Vercel Configuration

### Project Settings

The marketplace is configured with `vercel.json`:

```json
{
  "buildCommand": "npm install && npm run build",
  "outputDirectory": "dist",
  "installCommand": "npm install",
  "framework": "astro"
}
```

### Vercel Project Setup

The project is **already configured** with Vercel:

1. **Git Integration Connected:**
   - Repository: `AndroidNextdoor/stoked-automations`
   - Root directory: `marketplace/`
   - Framework: Astro (auto-detected)

2. **Project Linked Locally:**
   - `.vercel/project.json` contains project metadata
   - Project ID: `prj_jNEIhjs6q3TKjryaD0ptcP1ojcCt`

3. **Domain Configuration:**
   - Production domain: `stokedautomations.com`
   - Configured in Vercel Dashboard → Settings → Domains
   - SSL certificate: Automatic (Let's Encrypt)

## Local Development

### Run locally
```bash
cd marketplace/
npm install
npm run dev
```

### Build locally
```bash
npm run build
npm run preview  # Preview production build
```

### Deploy manually (if needed)
```bash
# Install Vercel CLI globally
npm install -g vercel

# Deploy to production
cd marketplace/
vercel --prod
```

## Environment Variables

The marketplace currently has **no environment variables** configured. All data comes from:
- Static JSON files in `marketplace/src/content/plugins/`
- Catalog files in `.claude-plugin/marketplace.extended.json`

If environment variables are needed in the future:
1. Add to Vercel Dashboard → Project Settings → Environment Variables
2. Set for **Production** environment
3. Redeploy to apply

## Troubleshooting

### Deployment Fails

**Check:**
1. Build succeeds locally: `cd marketplace && npm run build`
2. Check Vercel Dashboard → Deployments for build logs
3. Verify Git integration is connected in Vercel Dashboard → Settings → Git

### Build Succeeds but Site Not Updated

**Solutions:**
1. Clear Vercel cache: Redeploy from Vercel Dashboard
2. Check domain DNS settings
3. Wait 1-2 minutes for CDN to propagate

### Vercel Not Detecting Changes

**Fix:**
1. Check webhook in GitHub Settings → Webhooks (should see `hooks.vercel.com`)
2. Re-connect Git integration in Vercel Dashboard if needed
3. Trigger manual deployment from Vercel Dashboard → Deployments → Redeploy

## Migration from GitHub Pages

Previously, the marketplace was deployed to **GitHub Pages**. It has been migrated to **Vercel** for:

✅ Faster builds
✅ Better performance (edge CDN)
✅ Automatic preview deployments
✅ Advanced analytics
✅ Custom domain with SSL (automatic)

### What Changed

| Feature | GitHub Pages | Vercel |
|---------|-------------|--------|
| **URL** | github.io subdomain | stokedautomations.com |
| **Deployment** | GitHub Actions workflow | Automatic Git integration |
| **Build time** | ~2-3 minutes | ~1-2 minutes |
| **Preview deploys** | Manual only | Automatic for every PR |
| **SSL** | Automatic | Automatic |
| **CDN** | GitHub CDN | Global Edge Network |

### What Was Removed
- ❌ Removed `.github/workflows/deploy-marketplace.yml` (not needed)
- ❌ No more GitHub Actions for deployment
- ❌ No secrets or tokens required

## Monitoring

### Deployment Status
- **Vercel Dashboard:** https://vercel.com/dashboard
  - View all deployments (production + previews)
  - Real-time build logs
  - Deployment history

### Analytics
Available in Vercel Dashboard:
- Page views
- Performance metrics
- Bandwidth usage
- Edge function invocations

## Best Practices

1. **Always test locally before pushing**
   ```bash
   cd marketplace/
   npm run build
   npm run preview
   ```

2. **Use preview deployments for testing**
   - Push feature branch to GitHub
   - Vercel automatically creates preview URL
   - Test thoroughly before merging to main

3. **Monitor build times**
   - Keep dependencies minimal
   - Optimize images and assets
   - Use Astro's built-in optimizations

4. **Check deployment logs**
   - Monitor Vercel Dashboard after pushing
   - Review build logs for any warnings
   - Check runtime logs for errors

5. **Take advantage of automatic previews**
   - Every PR gets a unique preview URL
   - Share preview links for review
   - Test changes before merging

## Additional Resources

- [Vercel Documentation](https://vercel.com/docs)
- [Astro Documentation](https://docs.astro.build/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Vercel CLI Reference](https://vercel.com/docs/cli)

---

**Last Updated:** 2025-10-18
**Status:** Active (Vercel deployment live)
