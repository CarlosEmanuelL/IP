#!/bin/bash
# by Carlos Emanuel
##########

### FUNCOES

# Função para coletar IPs e portas do usuário
collect_ips_and_ports() {
	echo "Escolha uma opção para IPs de origem:"
	echo "1. Usar IPs individuais"
	echo "2. Usar ranges de IPs"
	read -p "Digite o número da opção desejada: " opcao_ips

	case $opcao_ips in
    	1)
        	echo "Digite os IPs de origem para gerenciamento (separados por espaço):"
        	read -a ips_origem_mng
        	echo "Digite os IPs de origem para trafego entre servidores que utilizam o servico (separados por espaço):"
        	read -a ips_origem
        	;;

    	2)
        	echo "Digite os ranges de IPs de origem para gerenciamento (formato 10.0.0.1-10.0.0.255, separados por espaço):"
        	read -a range_origem_mng
        	echo "Digite os IPs de origem para trafego entre servidores que utilizam o servico (separados por espaço):"
        	read -a range_origem
        	;;

    	*)
        	echo "Opção inválida. Escolha 1 para usar IPs individuais ou 2 para usar ranges de IPs."
        	return 1
        	;;
	esac

	echo "Digite as portas de gerencia que deseja bloquear (separadas por espaço):"
	read -a portas_gerencia_a_bloquear
	echo "Digite as portas de servico que deseja bloquear (separadas por espaço):"
	read -a portas_a_bloquear

	# Agora você pode usar ${ips_origem_mng[@]}, ${range_origem_mng[@]}, ${ips_origem[@]} e ${range_origem[@]} onde necessário.
}

#Função para criar o arquivo rc.local
create_rc_local() {
    local rc_local="/etc/rc.local"
    local script_line='#!/bin/bash\n\n# script para inicializar regras iptables para o servico\n/usr/local/bin/iptables.sh start\n\nexit 0'

    if [[ -f "$rc_local" ]]; then
   	 echo "O arquivo $rc_local já existe."
   	 echo "Criando o arquivo $rc_local com o script necessário..."
   	 sleep 2s

   	 # Cria o arquivo com o script
   	 echo -e "$script_line" | sudo tee "$rc_local" > /dev/null

   	 # Altera as permissões para torná-lo executável
   	 sudo chmod +x "$rc_local"

    else
   	 echo "Criando o arquivo $rc_local com o script necessário..."
   	 sleep 2s

   	 # Cria o arquivo com o script
   	 echo -e "$script_line" | sudo tee "$rc_local" > /dev/null

   	 # Altera as permissões para torná-lo executável
   	 sudo chmod +x "$rc_local"
    fi

    echo "Operação concluída."
    echo "  "
}

#Função para criar o arquivo rc-local.service
create_rc_local_service() {
    local service_file="/etc/systemd/system/rc-local.service"

    # Verifica se o arquivo já existe
    if [[ -f "$service_file" ]]; then
   	 echo "O serviço rc-local.service já existe."
   	 echo "Subscrevendo o arquivo já existente..."
   	 sleep 2s

   	 # Conteúdo do arquivo de serviço rc-local.service
   	 local service_content="[Unit]
Description=/etc/rc.local Compatibility
ConditionPathExists=/etc/rc.local

[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99

[Install]
WantedBy=multi-user.target"

   	 # Cria o arquivo de serviço
   	 echo "$service_content" | sudo tee "$service_file" > /dev/null

   	 # Altera as permissões para torná-lo executável
   	 sudo chmod +x "$service_file"

   	 echo "Serviço rc-local.service subscrevido com sucesso."
   	 echo "  "
    else
   	 echo "Criando o serviço systemd rc-local.service..."
   	 echo "  "
   	 sleep 2s

   	 # Conteúdo do arquivo de serviço rc-local.service
   	 local service_content="[Unit]
Description=/etc/rc.local Compatibility
ConditionPathExists=/etc/rc.local

[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99

[Install]
WantedBy=multi-user.target"

   	 # Cria o arquivo de serviço
   	 echo "$service_content" | sudo tee "$service_file" > /dev/null

   	 # Altera as permissões para torná-lo executável
   	 sudo chmod +x "$service_file"

   	 echo "Serviço rc-local.service criado com sucesso."
   	 echo "  "
    fi
}

# Funcao help nao precisa editar valor das variaveis aqui!
show_help() {
    echo "Use: $0 [start|stop|help]"
    echo "  #######################################################################"
    echo "  ##            	start: 	Iniciar Regras Iptables             	##"
    echo "  ##            	stop:  	Parar a execucao Regras Iptables    	##"
    echo "  ##            	list:  	Listar as regras                    	##"
    echo "  ##            	install:   Instala servico                     	##"
    echo "  ##            	uninstall: Desinstala o serviço                	##"
    echo "  ##            	help:  	Exibir mensagens de ajuda           	##"
    echo "  #######################################################################"
	echo "  "
}

#Move o script para o para o diretório /usr/local/bin
install_script() {
    local script_name="iptables.sh"
    local script_path="/usr/local/bin/$script_name"

    # Verifica se o script já existe no destino
    if [[ -f "$script_path" ]]; then
   	 echo "O script $script_name já existe em $script_path."
   	 echo "Subscrevendo o script em $script_path..."
   	 sleep 2s

   	 # Copia o script para /usr/local/bin
   	 sudo cp "$0" "$script_path"

   	 # Altera as permissões para torná-lo executável
   	 sudo chmod +x "$script_path"

   	 echo "Script instalado e permissão chmod +x aplicada."
   	 echo "  "
    else
   	 echo "Instalando o script em $script_path..."
   	 sleep 2s

   	 # Copia o script para /usr/local/bin
   	 sudo cp "$0" "$script_path"

   	 # Altera as permissões para torná-lo executável
   	 sudo chmod +x "$script_path"

   	 echo "Script instalado e permissão chmod +x aplicada."
   	 echo "  "
    fi
}

# Função para desinstalar os serviços
uninstall_services() {
	echo "Desinstalando serviços..."
	sleep 2s

	# Comente a linha que executa o seu script no arquivo /etc/rc.local
	sudo sed -i '/\/usr\/local\/bin\/iptables.sh start/s/^/#/' /etc/rc.local

	# Recarregue o serviço systemd para refletir as alterações em /etc/rc.local
	sudo systemctl daemon-reload

	echo "/etc/rc.local comentado."
	echo "  "

	# Remova o arquivo /etc/systemd/system/rc-local.service
	sudo rm -f /etc/systemd/system/rc-local.service

	# Remova o script do diretório /usr/local/bin
	sudo rm -f /usr/local/bin/iptables.sh

	echo "Serviços desinstalados com sucesso."
	echo "  "
}

start(){
    collect_ips_and_ports

    echo "Startando Regras Iptables.."
    sleep 2s

    # Limpar todas as regras existentes
    iptables -F

    # Permitir tráfego de loopback
    iptables -A INPUT -i lo -j ACCEPT
    iptables -A OUTPUT -o lo -j ACCEPT

    # obter nome da interface padrao
    interface=$(ip route | awk '/default/ {print $5}')

    # Permitir tráfego para as portas de Gerencia Web e SSH, para os IPs de origem especificados variavel ips_origem_
    for ip in "${ips_origem_mng[@]}"; do
    	for porta in "${portas_gerencia_a_bloquear[@]}"; do
   		 if [[ $porta == *":"* ]]; then
            	iptables -A INPUT -p tcp -m multiport --dports "$porta" -i "$interface" -s "$ip" -j ACCEPT
        	else
            	iptables -A INPUT -p tcp --dport "$porta" -i "$interface" -s "$ip" -j ACCEPT
        	fi
      	#  iptables -A INPUT -p tcp --dport "$porta" -i "$interface" -s "$ip" -j ACCEPT
    	done
	done
    for range in "${range_origem_mng[@]}"; do
    	for porta in "${portas_gerencia_a_bloquear[@]}"; do
   		 if [[ $porta == *":"* ]]; then
            	iptables -A INPUT -p tcp -m multiport --dports "$porta" -i "$interface" -s "$ip" -j ACCEPT
        	else
            	iptables -A INPUT -p tcp --dport "$porta" -i "$interface" -s "$ip" -j ACCEPT
        	fi
   	 #    iptables -A INPUT -p tcp -m multiport --dport "$porta" -i "$interface" -m iprange --src-range "$range" -j ACCEPT
    	done
	done

    # Permitir tráfego local para a portas do servico, para os IPs de origem especificados variavel ips_origem
    for ip in "${ips_origem[@]}"; do
    	for porta in "${portas_a_bloquear[@]}"; do
   		 if [[ $porta == *":"* ]]; then
            	iptables -A INPUT -p tcp -m multiport --dports "$porta" -i "$interface" -s "$ip" -j ACCEPT
        	else
            	iptables -A INPUT -p tcp --dport "$porta" -i "$interface" -s "$ip" -j ACCEPT
        	fi
       	# iptables -A INPUT -p tcp --dport "$porta" -i "$interface" -s "$ip" -j ACCEPT
    	done
	done
    for ip in "${range_origem[@]}"; do
    	for porta in "${portas_a_bloquear[@]}"; do
   		 if [[ $porta == *":"* ]]; then
            	iptables -A INPUT -p tcp -m multiport --dports "$porta" -i "$interface" -s "$ip" -j ACCEPT
        	else
            	iptables -A INPUT -p tcp --dport "$porta" -i "$interface" -s "$ip" -j ACCEPT
        	fi
      	#  iptables -A INPUT -p tcp -m multiport --dport "$porta" -i "$interface" -m iprange --src-range "$range" -j ACCEPT
    	done
	done

    # Negar todo o tráfego por padrão para portas de gerencia
    for porta in "${portas_gerencia_a_bloquear[@]}"; do
   	 if [[ $porta == *":"* ]]; then
   		 iptables -A INPUT -p tcp -m multiport --dports "$porta" -i "$interface" -j DROP
   	 else
   		 iptables -A INPUT -p tcp --dport "$porta" -i "$interface" -j DROP
   	 fi
   	# iptables -A INPUT -p tcp --dport "$porta" -i "$interface" -j DROP
	done
	# Negar todo o tráfego por padrão para portas de servico
	for porta in "${portas_a_bloquear[@]}"; do
   	 if [[ $porta == *":"* ]]; then
   		 iptables -A INPUT -p tcp -m multiport --dports "$porta" -i "$interface" -j DROP
   	 else
   		 iptables -A INPUT -p tcp --dport "$porta" -i "$interface" -j DROP
   	 fi
  	#  iptables -A INPUT -p tcp --dport "$porta" -i "$interface" -j DROP
	done
}

list(){
    echo "Lista Regras Iptables.."
    iptables -L
}

case "$1" in
    start)
   	 start
   	 list
   	 ;;
    stop)
   	 echo "Stoppando regras Iptables..."
    	sleep 2s
   	 iptables -F
   	 ;;
    list)
   	 list
   	 ;;
    help)
   	 show_help
   	 ;;
	 install)
   	 echo "Instalando servico..."
    	sleep 2s
    	echo "Criando arquivo /etc/rc.local"
    	sleep 2s
   	 create_rc_local
   	 create_rc_local_service
   	 install_script
   	 ;;
    uninstall)
   	 uninstall_services
   	 ;;
    *)
   	 echo "Argumento invalido: $1"
   	 show_help
   	 ;;
esac