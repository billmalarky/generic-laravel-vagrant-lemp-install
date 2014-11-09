## Generic Laravel/Vagrant/LEMP skeleton app.

This repo allows you to set up a skeleton Laravel app on the LEMP stack with Vagrant extremely easily.

Simply do a find and replace on the codebase for the string "generic" and replace that with your new project name. Make sure to also rename the several files with "generic" in their name as well.

After doing so, add the following line to your hosts file (of course replace "generic" with your project name).

192.168.100.100 generic.local

Then make sure you have virtualbox and vagrant installed on your development computer, navigate to the project directory and run "vagrant up"

Once your vagrant box is built, don't forget to run "composer install" in the project's root directory to automatically download all the laravel dependencies.

If you are developing in Windows 7, make sure to run virtualbox and cygwin as an administrator otherwise the symlinks that get created during vagrant provisioning will fail.

## License
This code is open-sourced software licensed under the [MIT license](http://opensource.org/licenses/MIT)
