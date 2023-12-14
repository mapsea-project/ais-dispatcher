module.exports = {
  apps: [
    {
      name: "AIS_Dispatcher",
      script: "python dispatcher.py",
      cwd: "./",
      instances: 1,
      autorestart: true,
      watch: true,
      max_memory_restart: "1G",
    }
  ]
};
