UBUNTU_22_04=$(lsb_release -r | grep "22.04")
UBUNTU_24_04=$(lsb_release -r | grep "24.04")

# needs either ubuntu 22.0.4 or 24.04
if [ -z "$UBUNTU_22_04" ] && [ -z "$UBUNTU_24_04" ]
then
    echo "AMD graphics package can not be installed. Ubuntu version could not be detected when checking lsb-release and /etc/os-release."
    exit 1
fi

if [ -n "$UBUNTU_22_04" ]
then
    distro="jammy"
else
    distro="noble"
fi

# https://amdgpu-install.readthedocs.io/en/latest/install-prereq.html#installing-the-installer-package

FILENAME="amdgpu-install_6.2.60202-1_all.deb"
set -e
mkdir -p /tmp/amd
cd /tmp/amd
curl -O -L http://repo.radeon.com/amdgpu-install/latest/ubuntu/$distro/$FILENAME
apt -y install rsync
dpkg -i $FILENAME
amdgpu-install --usecase=opencl --no-dkms -y --accept-eula
cd /tmp
rm -rf /tmp/amd
