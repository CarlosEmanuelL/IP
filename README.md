Introdução
Este repositório contém um script Bash poderoso desenvolvido por Carlos Emanuel para simplificar a configuração de regras iptables em servidores Linux. O script oferece uma solução flexível para fortalecer a segurança do servidor, permitindo um controle granular sobre o tráfego de rede com base em IPs e portas específicas.

Recursos Principais
Configuração Flexível:

Escolha entre IPs individuais ou ranges para gerenciamento e tráfego entre servidores.
Personalize as portas para bloquear o tráfego de gerenciamento e serviço.
Inicialização Automática:

Criação automática de arquivos rc.local e rc-local.service para aplicar regras iptables no boot.
Operações Simplificadas:

Opções para iniciar, parar, listar regras, instalar e desinstalar serviços.
Como Utilizar
Defina IPs e Portas:

Execute o script e siga as instruções para configurar IPs de origem, ranges, e portas desejadas.
Execução do Script:

Para iniciar as regras iptables, utilize o seguinte comando:
bash
./iptables.sh start

Personalização Adicional:

Adapte o script conforme suas necessidades específicas.
Por Que Usar iptables?
Segurança Reforçada: Controle preciso sobre as comunicações na rede.

Personalização Total: Adapte o script para atender às suas necessidades específicas.
Sinta-se à vontade para contribuir, abrir issues ou fornecer feedback.

