control 'ssh-package' do
  impact 1.0
  title 'OpenSSH Server debe estar instalado'
  describe package('openssh-server') do
    it { should be_installed }
  end
end

control 'ufw-package' do
  impact 1.0
  title 'UFW debe estar instalado'
  describe package('ufw') do
    it { should be_installed }
  end
end

control 'suricata-package' do
  impact 1.0
  title 'Suricata debe estar instalado'
  describe package('suricata') do
    it { should be_installed }
  end
end

control 'nginx-package' do
  impact 1.0
  title 'Nginx debe estar instalado'
  describe package('nginx') do
    it { should be_installed }
  end
end

control 'ssh-service' do
  impact 1.0
  title 'El servicio SSH debe estar activo y habilitado'
  describe service('ssh') do
    it { should be_enabled }
    it { should be_running }
  end
end

control 'ufw-service' do
  impact 1.0
  title 'El cortafuegos UFW debe estar activo'
  describe command('ufw status') do
    its('stdout') { should match /Status: active/ }
  end
end

control 'suricata-service' do
  impact 1.0
  title 'El servicio Suricata debe estar activo'
  describe service('suricata') do
    it { should be_enabled }
    it { should be_running }
  end
end

control 'nginx-service' do
  impact 1.0
  title 'El servicio Nginx debe estar activo'
  describe service('nginx') do
    it { should be_enabled }
    it { should be_running }
  end
end

control 'ssh-password-auth' do
  impact 1.0
  title 'SSH debe tener deshabilitada la autenticación por contraseña'
  describe sshd_config do
    its('PasswordAuthentication') { should cmp 'no' }
  end
end

control 'ufw-ssh-rule' do
  impact 1.0
  title 'UFW debe permitir el puerto SSH'
  describe command('ufw status') do
    its('stdout') { should match /22.*ALLOW/ }
  end
end

control 'ufw-http-rule' do
  impact 1.0
  title 'UFW debe permitir el puerto HTTP'
  describe command('ufw status') do
    its('stdout') { should match /80.*ALLOW/ }
  end
end

control 'nginx-index' do
  impact 1.0
  title 'La página index de Nginx debe estar desplegada'
  describe file('/var/www/html/index.html') do
    it { should exist }
    its('content') { should match /Servidor Víctima - Prueba de Seguridad/ }
  end
end

control 'suricata-rules' do
  impact 1.0
  title 'Suricata debe tener reglas instaladas'
  describe file('/var/lib/suricata/rules/suricata.rules') do
    it { should exist }
    its('size') { should > 0 }
  end
end
