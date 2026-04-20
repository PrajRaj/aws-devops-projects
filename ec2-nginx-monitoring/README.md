# EC2 Nginx Setup & Basic Monitoring

## Objective
Deploy Nginx on AWS EC2 and monitor system performance.

---

## Steps

1. Launch EC2 instance

2. Connect using SSH:
ssh -i key.pem ubuntu@ <public-ip>

3. Install Nginx:
sudo apt update
sudo apt install nginx -y

4. Start Nginx:
sudo systemctl start nginx
sudo systemctl enable nginx

5. Access in browser using public IP

---

## Monitoring Script

Created a file monitor.sh and added:

#!/bin/bash

`df -h` : Displays disk space usage in human-readable format  
`free -h` : Shows memory usage (RAM) in human-readable format  
`nproc` : Returns the number of CPU cores available

Run:
chmod +x monitor.sh
./monitor.sh

---

## Output Summary

- Disk: ~27% used  
- Memory: ~911MB total  
- CPU: 2 cores  

---

## Outcome

- Nginx deployed successfully  
- Basic system monitoring implemented  
- Resolved SSH key and setup issues  

---

