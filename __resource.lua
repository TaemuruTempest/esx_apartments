description 'ESX Apartments'
version '0.0.1'
dependencies{'es_extended', 'esx_menu_default', 'mysql-async'}

client_scripts{'config.lua', 'util.lua', 'client.lua'}
server_scripts{'@mysql-async/lib/MySQL.lua', 'config.lua', 'server.lua'}
