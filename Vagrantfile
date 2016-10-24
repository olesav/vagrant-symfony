Vagrant.require_version ">= 1.5"

# Check to determine whether we're on a windows or linux/os-x host,
# later on we use this to launch ansible in the supported way
# source: https://stackoverflow.com/questions/2108727/which-in-ruby-checking-if-program-exists-in-path-from-ruby
def which(cmd)
    exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
    ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
        exts.each { |ext|
            exe = File.join(path, "#{cmd}#{ext}")
            return exe if File.executable? exe
        }
    end
    return nil
end

Vagrant.configure("2") do |config|
    config.vm.provider :virtualbox do |v|
        v.name = "project_demo"
        v.customize [
            "modifyvm", :id,
            "--memory", 1024,
            "--natdnshostresolver1", "on",
            "--cpus", 1
        ]
        v.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/vagrant", "1"]
    end

    config.vm.box = "ubuntu/trusty32"
    config.vm.network :private_network, ip: "12.18.56.95"
    config.ssh.forward_agent = true

    if 1
        if Vagrant.has_plugin?("winnfsd") && Vagrant::Util::Platform::windows?
            puts "Vagrant launched from windows. Please install \"vagrant-winnfsd\" plugin for better perform."
            config.vm.synced_folder "./../", "/var/www/project", mount_options: ["dmode=777", "fmode=666"]
        else
            config.vm.synced_folder "./../", "/var/www/project", :nfs => true, mount_options: ["dmode=777", "fmode=666"]
        end
    else
        # Move /vendor to vagrant env
        config.vm.synced_folder "./../app", "/var/www/project/app"
        config.vm.synced_folder "./../src", "/var/www/project/src"
        config.vm.synced_folder "./../web", "/var/www/project/web"

        config.vm.provision "shell" do |sh|
            sh.inline = "chown www-data:www-data /var/www/project && chmod 777 /var/www/project"
        end

        config.vm.provision :file, source: "./../composer.json", destination: "/var/www/project/composer.json"
        config.vm.provision :file, source: "./../composer.lock", destination: "/var/www/project/composer.lock"
    end

    # If ansible is in your path it will provision from your HOST machine
    # If ansible is not found in the path it will be instaled in the VM and provisioned from there
    if which('ansible-playbook')
        config.vm.provision "ansible" do |ansible|
            ansible.playbook = "ansible/playbook.yml"
            ansible.inventory_path = "ansible/inventories/dev"
            ansible.limit = 'all'
        end

        config.vm.provision "ansible", run: "always" do |ansible|
            ansible.playbook = "ansible/symfony_playbook.yml"
            ansible.inventory_path = "ansible/inventories/dev"
            ansible.limit = 'all'
        end
    else
        config.vm.provision "shell", path: "ansible/windows.sh" do |sh|
            sh.path = "ansible/windows.sh"
            sh.args = "ansible/playbook.yml update"
        end

        config.vm.provision "shell", run: "always" do |sh|
            sh.path = "ansible/windows.sh"
            sh.args = "ansible/symfony_playbook.yml"
        end
    end
end
