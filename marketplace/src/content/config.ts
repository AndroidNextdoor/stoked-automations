import { defineCollection, z } from 'astro:content';

const pluginsCollection = defineCollection({
  type: 'data',
  schema: z.object({
    name: z.string(),
    displayName: z.string().optional(),
    description: z.string(),
    version: z.string(),
    category: z.enum([
      'accessibility',
      'ai-agency',
      'ai-ml',
      'ai-ml-assistance',
      'api-development',
      'automation',
      'business-tools',
      'cloud-infrastructure',
      'code-analysis',
      'code-quality',
      'crypto',
      'database',
      'debugging',
      'design',
      'devops',
      'documentation',
      'example',
      'finance',
      'frontend-development',
      'fullstack',
      'mobile',
      'packages',
      'performance',
      'productivity',
      'security',
      'skill-enhancers',
      'testing',
      'other'
    ]),
    type: z.enum(['standard', 'mcp']).optional(),
    keywords: z.array(z.string()),
    author: z.object({
      name: z.string(),
      email: z.string().email().optional(),
      url: z.string().url().optional()
    }),
    featured: z.boolean().optional().default(false),
    repository: z.string().url().optional(),
    license: z.string().optional(),
    installation: z.string(),
    features: z.array(z.string()).optional(),
    requirements: z.array(z.string()).optional(),
    screenshots: z.array(z.string()).optional(),
    tools: z.array(z.object({
      name: z.string(),
      description: z.string()
    })).optional(),
    usage: z.record(z.string()).optional(),
    examples: z.array(z.object({
      title: z.string(),
      description: z.string(),
      code: z.string()
    })).optional(),
    documentation: z.string().url().optional(),
    tags: z.array(z.string()).optional(),
    verified: z.boolean().optional(),
    downloads: z.number().optional(),
    rating: z.number().optional(),
    reviews: z.array(z.any()).optional(),
    createdAt: z.string().optional(),
    updatedAt: z.string().optional()
  })
});

export const collections = {
  'plugins': pluginsCollection
};
