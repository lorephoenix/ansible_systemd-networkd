Role Name
=========

The Ansible role configures systemd-networkd link, network, and netdev files. 
It will also configure systemd-resolved file, if needed.

    git clone https://github.com/lorephoenix/ansible-systemd-networkd systemd-networkd

Requirements
------------

A GNU/Linux system distribution that have adopted systemd.

Role Variables
--------------

#### Default variables for the role

1. defaults/main.yml

    # Cleanup all known network interfaces. When this option is enabled the role
    # will search for and remove all network interface files that match the 
    # prefix.
    defaults_systemd_interface_cleanup: <boolean>

    # Enable systemd-networkd and (re)start the service
    defaults_systemd_run_networkd: <boolean>

    # Enable or Disable the availability of systemd-resolved. This option is a
    # Boolean variable.
    defaults_systemd_resolved_available: "{{ systemd_resolved_enabled }}"


#### OS supported variables for the role

1. vars/(OS supported distribution).yml

    # For each Ansible supported Ansible OS family or Ansible distribution it
    # require to have the variable os_supported.
    os_supported: <boolean>

    # Software package required to be installed
    systemd_networkd_base_pkgs: 
      - <package_name_1>
      - <package_name_2>

    # Disable or enable systemd-resolved service.
    systemd_resolved_enabled: <boolean>


#### Playbook defined variables for the role

1. Possible variable options under vars 'systemd_networks'

    # Mandatory
     - interface: <interface_name>

    # For creating systemd.link - Network device configuration to configure 
    # low-level link settings independently of networks then use the option 
    # 'udev', which isn't part of any systemd_networkd section options and keys. 
    # Takes a boolean argument. If true then all available keys specified for
    # section [Link] will be stored to an interface file with the file extension
    # .link. If false or not specified all available keys specified for section
    # [Link] will be stored to an interface file with the file extension
    # .network.
    udev: <boolean>

    # Available key variables that can be used for low-level link setttings
    # can be found on URL
    # 'https://www.freedesktop.org/software/systemd/man/systemd.link.html'
    # These key variables can also be used under systemd_networks.
    # Example 1:
    vars:
      systemd_networks:
        - interface: eth0
          Host: myhost1
          Path: pci-0000:01:00.0
          Description: production interface
          MTUBytes: 1500

    # To make it cleaner you can specify the section name first and below that
    # you can defined the key variables linked to that section name.
    vars:
      systemd_networks:
        - interface: eth0
          Match:
            Host: myhost1
            Path: pci-0000:01:00.0
          Link:
            Description: production interface
            MTUBytes: 1500

    # Based on Example 1 input will create a network file 'eth0.network' that 
    # contains the following data.
    [Match]
    Host: myhost1
    Path: pci-0000:01:00.0

    [Link]
    Description: production interface
    MTUBytes: 1500

    # Available key variables that can be used for network devices based on the
    # the configuration in systemd.netdev.
    # URL: 'https://www.freedesktop.org/software/systemd/man/systemd.netdev.html'

    # Only key variables in systemd.network within the following section options
    # [Match], [Link], [Network], [DHCPv4], [DHCPv6], [Address] and [Route] can
    # be used.
    # URL: 'https://www.freedesktop.org/software/systemd/man/systemd.network.html'
    

2. Possible variable options under vars 'systemd_resolved'

    # A space-separated list of IPv4 and IPv6 addresses to use as system DNS
    # servers.
    DNS: <list>

    # A space-separated list of IPv4 and IPv6 addresses to use as the fallback 
    # DNS servers.
    FallbackDNS: <list>

    # A space-separated list of domains. These domains are used as search 
    # suffixes when resolving single-label host names, in order to qualify them
    # into fully-qualified domain names (FQDNs).
    Domains: <list>

    # Takes a boolean argument or "resolve". Controls Link-Local Multicast Name
    # Resolution support (RFC 4795) on the local host. If true, enables full 
    # LLMNR responder and resolver support. If false, disables both. If set to 
    # "resolve", only resolution support is enabled, but responding is disabled.
    LLMNR: <boolean>|'resolve'

    # Takes a boolean argument or "resolve". Controls Multicast DNS support 
    # (RFC 6762) on the local host. If true, enables full Multicast DNS 
    # responder and resolver support. If false, disables both. If set to 
    # "resolve", only resolution support is enabled, but responding is disabled. 
    MulticastDNS: <boolean>|'resolve'

    # Takes a boolean argument or "allow-downgrade". If true all DNS lookups are
    # DNSSEC-validated locally (excluding LLMNR and Multicast DNS). If the 
    # response to a lookup request is detected to be invalid a lookup failure is
    # returned to applications. 
    #
    # Note that this mode requires a DNS server that supports DNSSEC. If the DNS
    # server does not properly support DNSSEC all validations will fail. If set
    # to "allow-downgrade" DNSSEC validation is attempted, but if the server 
    # does not support DNSSEC properly, DNSSEC mode is automatically disabled.
    #
    # Note that this mode makes DNSSEC validation vulnerable to "downgrade" 
    # attacks, where an attacker might be able to trigger a downgrade to 
    # non-DNSSEC mode by synthesizing a DNS response that suggests DNSSEC was 
    # not supported. If set to false, DNS lookups are not DNSSEC validated.
    DNSSEC: <boolean>|'allow-downgrade'

    # Takes a boolean argument or "opportunistic". If true all connections to 
    # the server will be encrypted. Note that this mode requires a DNS server
    # that supports DNS-over-TLS and has a valid certificate for it's IP. If the
    # DNS server does not support DNS-over-TLS all DNS requests will fail. 
    # When set to "opportunistic" DNS request are attempted to send encrypted
    # with DNS-over-TLS. If the DNS server does not support TLS, DNS-over-TLS is
    # disabled. Note that this mode makes DNS-over-TLS vulnerable to "downgrade"
    # attacks, where an attacker might be able to trigger a downgrade to 
    # non-encrypted mode by synthesizing a response that suggests DNS-over-TLS
    # was not supported. If set to false, DNS lookups are send over UDP.
    DNSOverTLS: <boolean>|'opportunistic'

    # Takes a boolean or "no-negative" as argument. If "yes" (the default), 
    # resolving a domain name which already got queried earlier will return the
    # previous result as long as it is still valid, and thus does not result in
    # a new network request. Be aware that turning off caching comes at a 
    # performance penalty, which is particularly high when DNSSEC is used.
    # If "no-negative", only positive answers are cached.
    Cache: <boolean>|'no-negative'

    # Takes a boolean argument or one of "udp" and "tcp". If "udp", a DNS stub
    # resolver will listen for UDP requests on address 127.0.0.53 port 53.
    # If "tcp", the stub will listen for TCP requests on the same address and
    # port. If "yes" (the default), the stub listens for both UDP and TCP 
    # requests. If "no", the stub listener is disabled.
    DNSStubListener: <boolean>|'udp'|'tcp'

    # Takes a boolean argument. If "yes" (the default), the DNS stub resolver 
    # will read /etc/hosts, and try to resolve hosts or address by using the
    # entries in the file before sending query to DNS servers.
    ReadEtcHosts: <boolean>


Dependencies
------------

<ul><li>Ansible >= 2.9</li></ul>

Example Playbook
----------------

This is an example playbook:

    - hosts: localhost
      remote_user: ansible
      become: True
      become_method: sudo
      become_user: root
      gather_facts: True
      roles:
        - role: systemd-networkd
      
      vars:
        systemd_resolved:
          DNS: '192.168.1.1'
          FallbackDNS: '8.8.8.8 8.8.4.4'
          Cache: yes
          DNSOverTLS: no
          DNSSEC: 'allow-downgrade'
          DNSStubListener: yes
          Domains: 'example.com example.net'
          LLMNR: no
          MulticastDNS: no
          ReadEtcHosts: no
          
        systemd_networks:
          - interface: eth0
            Description: Production interface
            MACAddress: 15:44:47:d3:fa:91
            Match:
              Architecture: x86-64
              Host: myhostname
              Virtualization: false
            Link:
              ARP: yes
              MTUBytes: 1500  
              Multicast: yes
            Network:
              DHCP: no
              EmitLLDP: nearest-bridge
              LLDP: routers-only
            Address:
              Address: 192.168.1.16/24
            Route:
              Gateway: 192.168.1.1
              GatewayOnLink: yes
            
  

License
-------

MIT

Author Information
------------------

- Christophe Vermeren | [GitHub](https://github.com/lorephoenix) | [Facebook](https://www.facebook.com/cvermeren)
