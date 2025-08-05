#!/bin/bash

echo "🚀 Starting containers..."
docker-compose up -d --build

echo "⏳ Waiting for database container to be ready..."

# Wait until MySQL is ready
until docker exec drupal_db mysqladmin ping -h "localhost" -udrupal -pdrupal --silent; do
    echo "⏳ Waiting for MySQL to respond..."
    sleep 5
done

echo "✅ Database container is ready."

echo "📄 Setting up settings.php..."
docker exec -it drupal_web bash -c "cp -n sites/default/default.settings.php sites/default/settings.php && chmod 664 sites/default/settings.php && chown www-data:www-data sites/default/settings.php"

echo "💾 Importing drupal_backup.sql..."
docker exec -i drupal_db mysql -udrupal -pdrupal drupal < drupal_backup.sql

echo "🔁 Running drush cr..."
docker exec drupal_web ./vendor/bin/drush cr || echo "Drush not found"

echo "✅ Drupal is ready at: http://<EC2-IP>:8080"

