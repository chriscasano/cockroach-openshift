cd ~

# Linux
#wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz

#Mac
wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-mac-4.7.0.tar.gz

mkdir openshift
tar -zxvf openshift-client-linux.tar.gz -C openshift
echo 'export PATH=$PATH:~/openshift' >> ~/.bashrc && source ~/.bashrc
