#!/bin/bash

echo "🚀 Starting Docker containers..."
docker-compose up -d

echo "⏳ Waiting for the database to initialize..."
sleep 15

echo "✅ Setting permissions for settings.php..."

docker exec -it drupal_web bash -c "cp sites/default/default.settings.php sites/default/settings.php && chmod 664 sites/default/settings.php && chown www-data:www-data sites/default/settings.php"

echo "✅ Setup complete!"
echo "Open your browser at: http://localhost:8080"
echo "Use these DB settings during installation:"
echo "  DB host: db"
echo "  DB name: drupal"
echo "  DB user: drupal"
echo "  DB password: drupal"

