package 'libxml2-dev'
package 'libxslt-dev'

execute 'create pg user for vagrant' do
  command 'createuser -U postgres -s vagrant'
  not_if 'test $(psql -U postgres -tc "select count(*) from pg_user where usename=\'vagrant\'") -eq 1'
end
