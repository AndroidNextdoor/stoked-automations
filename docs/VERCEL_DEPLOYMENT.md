# Vercel Deployment Guide

This guide explains how the Stoked Automations marketplace is deployed to Vercel.

## Overview

The marketplace (Astro website) is automatically deployed to **Vercel** on every push to the `main` branch. The live site is available at https://stokedautomations.com.

## Deployment Architecture

```
GitHub (main branch)
    ↓
GitHub Actions Workflow
    ↓
Vercel CLI (build + deploy)
    ↓
Production (stokedautomations.com)
```

## GitHub Actions Workflow

### Workflow File
`.github/workflows/deploy-marketplace.yml`

### Triggers
- **Push to main:** Deploys when changes are pushed to `main` branch in `marketplace/` directory
- **Manual dispatch:** Can be triggered manually from GitHub Actions UI

### Steps
1. **Checkout repository**
2. **Setup Node.js 20**
3. **Install Vercel CLI**
4. **Pull Vercel environment** (downloads project settings)
5. **Build artifacts** with `vercel build --prod`
6. **Deploy to production** with `vercel deploy --prebuilt --prod`

### Required GitHub Secret

The workflow requires **one GitHub secret**:

| Secret Name | Description | How to Get |
|-------------|-------------|------------|
| `VERCEL_TOKEN` | Vercel authentication token | Generate from Vercel Dashboard → Settings → Tokens |

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

1. **Link to Vercel project:**
   ```bash
   cd marketplace/
   vercel link
   ```

2. **Project is already linked:**
   - The `.vercel/` directory contains project metadata
   - Project ID and org ID are stored locally

3. **Domain configuration:**
   - Primary domain: `stokedautomations.com`
   - Configured in Vercel Dashboard → Domains

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
1. `VERCEL_TOKEN` secret is set in GitHub
2. Vercel token has not expired
3. Build succeeds locally: `cd marketplace && npm run build`
4. Check GitHub Actions logs for specific errors

### Build Succeeds but Site Not Updated

**Solutions:**
1. Clear Vercel cache: Redeploy from Vercel Dashboard
2. Check domain DNS settings
3. Wait 1-2 minutes for CDN to propagate

### "Failed to pull Vercel environment"

**Fix:**
- Verify `.vercel/` directory exists in `marketplace/`
- Re-link project: `cd marketplace && vercel link`
- Commit updated `.vercel/project.json`

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
| **Deployment** | GitHub Actions | GitHub Actions + Vercel CLI |
| **Build time** | ~2-3 minutes | ~1-2 minutes |
| **SSL** | Automatic | Automatic |
| **CDN** | GitHub CDN | Global Edge Network |

### Old Workflow (Removed)
- Removed `actions/upload-pages-artifact@v4`
- Removed `actions/deploy-pages@v4`
- Removed `pages: write` permission

## Monitoring

### Deployment Status
- **GitHub Actions:** https://github.com/AndroidNextdoor/stoked-automations/actions
- **Vercel Dashboard:** https://vercel.com/dashboard

### Analytics
Available in Vercel Dashboard:
- Page views
- Performance metrics
- Bandwidth usage
- Edge function invocations

## Best Practices

1. **Always test locally before pushing to main**
   ```bash
   cd marketplace/
   npm run build
   npm run preview
   ```

2. **Use preview deployments for testing**
   - Feature branches automatically get preview URLs
   - Test before merging to main

3. **Monitor build times**
   - Keep dependencies minimal
   - Optimize images and assets
   - Use Astro's built-in optimizations

4. **Check deployment logs**
   - Review GitHub Actions logs after each deployment
   - Monitor Vercel logs for runtime errors

## Additional Resources

- [Vercel Documentation](https://vercel.com/docs)
- [Astro Documentation](https://docs.astro.build/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Vercel CLI Reference](https://vercel.com/docs/cli)

---

**Last Updated:** 2025-10-18
**Status:** Active (Vercel deployment live)
