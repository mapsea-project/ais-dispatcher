# AIS dispatcher

시리얼 또는 UDP 입력 포트에서 AIS 데이터를 수신합니다.

스레드형 TCP 서버를 시작하여 AIS 데이터를 전달하기 위해 연결을 수락합니다.

목적지 목록에 UDP 페이로드로 AIS 데이터를 전송합니다.*

*이는 동일한 기계에서 실행되는 다른 도구들(예를 들어, aishub dispatcher)이 입력으로 이를 읽을 수 있도록 localhost를 포함할 수 있음

## Prerequisits

- python3
- 추가 파이썬 패키지
  - `sudo pip3 install pyserial click`

## Usage

Example:
`./dispatcher.py --host 192.168.1.4 1371 --serial-port /dev/serial0`

여기서 IP는 서비스를 제공할 로컬 기계의 인터페이스 주소입니다(이 예시에서는 포트 1371을 사용).

전체 인자 목록은 --help로 제공됩니다.

```
Usage: dispatcher.py [OPTIONS]

Options:
  --host <TEXT INTEGER>...      호스트 <ip> <port> - 서버를 연결할 로컬 인터페이스 [필수]
  --serial-port TEXT            시리얼 장치. (예: /dev/serial0)
  --serial-rate INTEGER         Serial port baudrate (default 38400)
  --udp-src <TEXT INTEGER>...   UDP 소스 <ip> <port> (일반적으로 --host와 같은 IP지만 다른 포트에서 수신)
  --udp-dest <TEXT INTEGER>...  UDP 전달 목적지 <ip> <port>
  --help                        이 메시지를 표시하고 종료.
```

여러 UDP 목적지의 경우, 스크립트와 같은 디렉토리에 *upd_destinations.json* 파일을 생성하고 다음과 같은 내용을 작성하세요:


```
[
  ["192.168.1.3", 1371],
  ["192.168.1.11", 1371],
  ["data.aishub.net", 1235],
  ["localhost", 1371]
]
```

명령줄에서 --udp-dest를 사용하면 이는 무시됩니다.

The dispatcher는 ctrl-c 또는 `sudo kill -s SIGINT <pid>`로 깔끔하게 중지할 수 있습니다.

## As a systemd service

일반적으로 systemd 서비스는 다음과 같이 보일 것입니다:

```
[Unit]
Description=AIS Dispatcher
After=network-online.target
Wants=network-online.target systemd-networkd-wait-online.service

StartLimitIntervalSec=500
StartLimitBurst=5

[Service]
Restart=on-failure
RestartSec=5s

StandardOutput=journal+console
ExecStart=/usr/bin/python3 /home/pi/AIS/dispatcher.py --host 192.168.1.4 1371 --serial-port /dev/serial0

[Install]
WantedBy=multi-user.target
```

예를 들어 - 이것을 */usr/lib/systemd/system/ais-dispatcher.service* 파일에 넣고 다음으로 활성화하세요:

```
sudo systemctl enable /usr/lib/systemd/system/ais-dispatcher.service
sudo systemctl start ais-dispatcher.service
```

시작된 유닛의 상태는 다음 중 하나로 확인할 수 있습니다:
```
systemctl status ais-dispatcher.service
journalctl -u ais-dispatcher.service
```

이 시점에서 구성된 인터페이스의 1371 포트로 telnet(또는 nc)을 사용하여 AIS 스트림을 얻을 수 있을 것입니다.
