**Readme.md - Script iptables.sh**

# Automatização de Segurança com iptables no Linux

Este script em bash, desenvolvido por Carlos Emanuel, oferece uma solução eficaz para configurar e gerenciar regras iptables em servidores Linux. A ferramenta é projetada para proporcionar um controle granular sobre o tráfego de rede, reforçando a segurança contra ameaças externas e facilitando a administração do sistema.

## Recursos Principais

1. **Configuração Flexível:**
   - Escolha entre IPs individuais ou ranges para gerenciamento.
   - Defina portas para bloquear o tráfego de gerenciamento e serviço.

2. **Inicialização Automática:**
   - Criação automática de arquivos `rc.local` e `rc-local.service` para aplicar regras iptables no boot.
   - Garante que as regras estejam sempre ativas, mesmo após reinicializações.

3. **Operações Simplificadas:**
   - Opções para iniciar, parar, listar regras, instalar e desinstalar serviços.
   - Facilita a manutenção e a administração do firewall.

## Como Utilizar

1. **Configuração:**
   - Execute o script e escolha IPs, ranges e portas conforme suas necessidades.
   - Personalize o comportamento do firewall de acordo com as políticas de segurança desejadas.

2. **Inicialização e Parada:**
   - Utilize os comandos `./iptables.sh start` para iniciar e `./iptables.sh stop` para parar as regras iptables.

3. **Listagem de Regras:**
   - Visualize as regras atuais com o comando `./iptables.sh list`.

4. **Instalação e Desinstalação:**
   - Para instalar o serviço, execute `./iptables.sh install`.
   - Para desinstalar, utilize `./iptables.sh uninstall`.

## Por que iptables?

- **Segurança Avançada:**
  - Controle preciso sobre as comunicações na rede.
  - Proteção robusta contra ameaças externas.

- **Flexibilidade Total:**
  - Adapte as regras conforme as necessidades específicas do seu ambiente.

## Contribuições

Sinta-se à vontade para contribuir, reportar problemas ou sugerir melhorias. Estamos comprometidos em manter este script atualizado e útil para a comunidade.

**Divirta-se automatizando a segurança do seu servidor com iptables!** 💻🔒
