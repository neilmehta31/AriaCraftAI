# Dockerfile.ipfs
FROM ipfs/kubo:0.7.0

EXPOSE 4001
EXPOSE 5001
EXPOSE 8080

CMD ["ipfs", "daemon"]