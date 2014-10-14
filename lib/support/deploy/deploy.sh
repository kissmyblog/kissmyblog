# This is deploy script we use to update our production server
# You can always modify it for your needs :)

# If any command return non-zero status - stop deploy
set -e

echo 'Deploy: Show deploy index page'
cp ~/kissmyblog/public/deploy.html ~/kissmyblog/public/index.html

echo 'Deploy: Stop KISSmyBLOG server'
/etc/init.d/kissmyblog stop

echo 'Deploy: Get latest code'
cd ~/kissmyblog

# clean working directory
# git stash

# change branch to
git fetch --all && git checkout master && git reset origin/master --hard

echo 'Deploy: Bundle & Compile assets'

# change it to your needs
bundle --without development test --deployment

bundle exec rake assets:clean RAILS_ENV=production
bundle exec rake assets:precompile RAILS_ENV=production

# return stashed changes (if necessary)
# git stash pop

echo 'Deploy: Starting KISSmyBLOG server...'
/etc/init.d/kissmyblog start

rm ~/kissmyblog/public/index.html
echo 'Deploy: Done'
