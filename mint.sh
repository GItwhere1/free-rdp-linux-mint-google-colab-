wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip > /dev/null 2>&1
unzip ngrok-stable-linux-amd64.zip > /dev/null 2>&1
read -p "Paste authtoken here https://dashboard.ngrok.com/get-started/your-authtoken (Copy and Ctrl+V to paste then press Enter): " CRP
./ngrok authtoken $CRP
echo region
read -p "region: " region
nohup ./ngrok tcp -region $region 5900 &>/dev/null &
mkdir mint
cd mint
echo update
sudo apt update -y > /dev/null 2>&1
echo install qemu
sudo apt install qemu-system-x86 curl -y > /dev/null 2>&1
echo install mint iso
wget https://mirrors.layeronline.com/linuxmint/stable/20.3/linuxmint-20.3-cinnamon-64bit.iso
echo making disk
qemu-img create mint.vdi 100G
echo Your VNC IP Address:
curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"tcp:..([^"]*).*/\1/p'
sudo qemu-system-x86_64 -cdrom linuxmint-20.3-cinnamon-64bit.iso -vnc :0 -hda mint.vdi -smp cores=8  -m 12000M -machine usb=on -device usb-tablet > /dev/null 2>&1
