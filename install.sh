#!/bin/bash

echo "🐳 Starting Drupal containers..."
docker-compose down
docker-compose up -d

# ⏳ Wait until MySQL is ready
echo "⌛ Waiting for MySQL to be ready..."
until docker exec drupal_db mysqladmin ping -h "localhost" -udrupal -pdrupal --silent; do
    echo "⏳ Waiting for MySQL to respond..."
    sleep 5
done
echo "✅ Database container is ready."

# 📄 settings.php setup
echo "📄 Setting up settings.php..."
docker exec drupal_web bash -c "cp -n sites/default/default.settings.php sites/default/settings.php && chmod 664 sites/default/settings.php && chown www-data:www-data sites/default/settings.php"

# 💾 Import SQL dump
echo "💾 Importing drupal_backup.sql..."
docker exec drupal_db sh -c "mysql -udrupal -pdrupal drupal < /drupal_backup.sql"

# 🔁 Clear Drupal cache
echo "🔁 Running drush cr..."
docker exec drupal_web ./vendor/bin/drush cr || echo "⚠️ Drush not found or not installed"

# ✅ Done
echo "✅ Drupal is ready at: http://localhost:8090"


