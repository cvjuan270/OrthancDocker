#!/bin/bash

# Directorio donde están los backups
BACKUP_DIR="./backups"

# Nombre del backup a restaurar (modificar según necesidad)
DB_BACKUP="$BACKUP_DIR/backup_orthanc_db_YYYYMMDD.sql.gz"
DICOM_BACKUP="$BACKUP_DIR/backup_orthanc_dicom_YYYYMMDD.tar.gz"

# Restaurar la base de datos PostgreSQL
echo "Iniciando restauración de PostgreSQL..."
gunzip -c "$DB_BACKUP" | docker exec -i orthanc-postgres psql -U orthanc -d orthanc
echo "Restauración de PostgreSQL completada."

# Restaurar archivos DICOM
echo "Iniciando restauración de archivos DICOM..."
docker run --rm --volumes-from orthanc-server -v "$BACKUP_DIR":/backup ubuntu \
  tar xzf "/backup/$(basename "$DICOM_BACKUP")" -C /
echo "Restauración de archivos DICOM completada."

echo "Restauración finalizada con éxito."
