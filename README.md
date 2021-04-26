~~~
Beginner qtile install scripts with everything needed to get started on arch linux. For this to work, the user must be running an nvidia graphics card. If not, Please comment out the nvidia packages and install with your appropriate graphics packages. I also have an intel processor. If you have an amd processor, please comment out the 'intel-ucode' package and add 'amd-ucode' from the base_install script. These scripts are also assuming a btrfs file system. If that is not what you are looking for you can comment the btrfs-progs package and modify it as you please.
~~~

# UNTESTED ON MY LOCAL MACHINE
## I have not reinstalled linux since finalizing these scripts.

This is a collection of arch linux install scripts include my custom config directory and makes use of the linux-lts kernel. It also has some parts of the script commented out. For example, bluetooth. I am not using bluetooth at the moment so i've got no need to install that functionality. If you would like that functionality, simply uncomment the relevant parts of the script before running. 

# Installtion:
~~~
git clone https://github.com/jtw023/install_script.git
chmod -Rv +x install_script/
~~~

Run the first script "base_install.sh" after the initial pacstrap command. For example:

After formatting your drive run the command:

~~~
pacstrap /mnt base linux-lts linux-firmware git vim
~~~

When each script finishes it will tell you what to do and which script to run next.  
