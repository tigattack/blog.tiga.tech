const glob = require('glob');
const path = require('path');
const http = require('http');
const fs = require('fs');

const PORT = 5338;

// Simple static file server
const server = http.createServer((req, response) => {
  const filePath = path.join(__dirname, '../../public', req.url === '/' ? 'index.html' : req.url);
  
  fs.readFile(filePath, (err, data) => {
    if (err) {
      response.writeHead(404);
      response.end('Not found');
      return;
    }
    
    const ext = path.extname(filePath);
    const contentType = {
      '.html': 'text/html',
      '.css': 'text/css',
      '.js': 'application/javascript',
      '.json': 'application/json',
      '.png': 'image/png',
      '.jpg': 'image/jpeg',
      '.jpeg': 'image/jpeg',
      '.webp': 'image/webp',
      '.svg': 'image/svg+xml',
      '.woff': 'font/woff',
      '.woff2': 'font/woff2'
    }[ext] || 'application/octet-stream';
    
    response.writeHead(200, { 'Content-Type': contentType });
    response.end(data);
  });
});

module.exports = async () => {
  // Start server
  await new Promise((resolve) => {
    server.listen(PORT, () => {
      console.log(`Serving public directory at http://localhost:${PORT}`);
      resolve();
    });
  });

  // Get all HTML files matching the pattern
  const files = glob.sync('public/{posts,categories,series,about,contact,projects}/**/*.html', {
    ignore: '**/page/1/index.html'
  });

  return files.map(file => {
    const relativePath = path.relative('public', file);
    const name = relativePath.replace(/\.html$/, '');
    
    const snapshot = {
      name,
      url: `http://localhost:${PORT}/${relativePath}`
    };

    // Only add execute for posts
    if (file.includes('/posts/')) {
      snapshot.execute = function() {
        // Force all lazy images to load eagerly
        document.querySelectorAll('img[loading="lazy"]').forEach(img => {
          img.loading = 'eager';
        });
        // Scroll to trigger lazy load
        window.scrollTo(0, document.body.scrollHeight);
        window.scrollTo(0, 0);
      };
    }

    return snapshot;
  });
};
