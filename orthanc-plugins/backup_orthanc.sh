#!/bin/bash

# Directorio donde se guardarán los backups
BACKUP_DIR="/var/backups/orthanc"
mkdir -p "$BACKUP_DIR"

# Fecha actual para nombrar los archivos
DATE=$(date +"%Y%m%d")

# Backup de la base de datos PostgreSQL
echo "Iniciando backup de PostgreSQL..."
docker exec orthanc-postgres pg_dump -U orthanc -d orthanc | gzip >"$BACKUP_DIR/backup_orthanc_db_$DATE.sql.gz"
echo "Backup de PostgreSQL completado: $BACKUP_DIR/backup_orthanc_db_$DATE.sql.gz"

# Backup de los archivos DICOM
echo "Iniciando backup de archivos DICOM..."
docker run --rm --volumes-from orthanc-server -v "$BACKUP_DIR":/backup ubuntu \
  tar czf /backup/backup_orthanc_dicom_$DATE.tar.gz /var/lib/orthanc/db
echo "Backup de archivos DICOM completado: $BACKUP_DIR/backup_orthanc_dicom_$DATE.tar.gz"

echo "Backup finalizado con éxito."
