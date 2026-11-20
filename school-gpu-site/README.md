# KIT GPU 서버 통합 관리 사이트 — 구축 안내서

처음 만드는 사람이 순서대로 따라 할 수 있도록 만든 Jupyter 노트북 9개와, 이를 하나로 묶은 PDF 입니다.

| 순서 | 노트북 | 내용 |
|---|---|---|
| 0 | [00_overview](00_overview.ipynb) | 전체 구조, 역할, 자리표시자 표, 콘솔 작업 요령 |
| 1 | [01_network_private_ip](01_network_private_ip.ipynb) | 공인 IP → 사설 IP, DNS, 방화벽 |
| 2 | [02_bootstrap_mgmt](02_bootstrap_mgmt.ipynb) | K3s · ArgoCD · Sealed Secrets · Tailscale 설치 |
| 3 | [03_tailscale_funnel](03_tailscale_funnel.ipynb) | 학교 밖 접속(Funnel) |
| 4 | [04_secrets_deploy](04_secrets_deploy.ipynb) | 비밀값, GitHub 토큰, 사이트 배포 |
| 5 | [05_accounts](05_accounts.ipynb) | 학과장 · 관리자 · 학생 계정 |
| 6 | [06_join_servers](06_join_servers.ipynb) | 서버 등록(가입), 관리 서버 자신, 재가입 |
| 7 | [07_operations](07_operations.ipynb) | 웹 터미널·파일 탐색기, 만료, 강제 재시작, 배포 |
| 8 | [08_troubleshooting](08_troubleshooting.ipynb) | 실제로 겪은 문제 22가지와 해결 |

PDF: [KIT-GPU-Server-Build-Guide.pdf](KIT-GPU-Server-Build-Guide.pdf)

- 노트북의 셀은 **문서**입니다. 설명된 위치(서버 콘솔·내 PC·사이트)에서 직접 실행하세요.
- 값은 모두 `[자리표시자]` 입니다. 실제 주소·토큰·비밀번호는 포함하지 않습니다.

