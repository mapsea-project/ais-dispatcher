module.exports = {
  apps: [
    {
      name: "AIS_Dispatcher",
      script: "python dispatcher.py --serial-port /dev/serial0 --serial-rate 38400 --host 0.0.0.0 4002",
      cwd: "./",
      instances: 1,
      autorestart: true,
      watch: true,
      max_memory_restart: "1G",
    }
  ]
};
