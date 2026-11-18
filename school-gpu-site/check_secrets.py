"""안내서에 실제 비밀·내부 주소가 섞이지 않았는지 검사한다.  실행:  python docs/guide/check_secrets.py [폴더]

공개 저장소에 올리기 전에 반드시 통과해야 한다. 걸리면 종료 코드 1.
PDF 는 pymupdf 가 있으면 글자도 검사한다.
"""
from __future__ import annotations

import pathlib
import re
import sys

PATTERNS = {
    "GitHub 토큰": r"gh[pousr]_[A-Za-z0-9]{20,}",
    "GitHub fine-grained 토큰": r"github_pat_[A-Za-z0-9_]{20,}",
    "API 키(sk-)": r"\bsk-[A-Za-z0-9_-]{20,}",
    "인증 앱 주소(비밀 키 포함)": r"otpauth://[^\s\"']*secret=[A-Z2-7]{16,}",
    "학교 공인 대역": r"\b202\.31\.\d{1,3}\.\d{1,3}",
    "내부 사설 대역(192.168.68)": r"\b192\.168\.68\.\d{1,3}",
    "실제 tailnet 이름": r"\btail[0-9a-f]{6}\.ts\.net",
    "긴 16진수(키·해시 의심)": r"\b[0-9a-f]{32,}\b",
    "긴 base32(인증 키 의심)": r"\b[A-Z2-7]{32,}\b",
    "비공개 키 블록": r"-----BEGIN [A-Z ]*PRIVATE KEY-----",
}
SELF = pathlib.Path(__file__).resolve()
TEXT_EXT = {".ipynb", ".md", ".svg", ".py", ".txt", ".html", ".json", ".yaml", ".yml"}


def scan_text(name: str, text: str, hits: list[str]) -> None:
    for label, pat in PATTERNS.items():
        for m in re.finditer(pat, text):
            s = m.group(0)
            hits.append(f"{name}: {label}: {s[:6]}…({len(s)}자)")


def main() -> int:
    sys.stdout.reconfigure(encoding="utf-8")
    root = pathlib.Path(sys.argv[1]) if len(sys.argv) > 1 else SELF.parent
    hits: list[str] = []
    n = 0
    for p in sorted(root.rglob("*")):
        if not p.is_file() or p.resolve() == SELF or ".git" in p.parts:
            continue
        if p.suffix.lower() in TEXT_EXT:
            scan_text(str(p.relative_to(root)), p.read_text(encoding="utf-8", errors="replace"), hits)
            n += 1
        elif p.suffix.lower() == ".pdf":
            try:
                import fitz  # pymupdf
            except ImportError:
                print(f"건너뜀(pymupdf 없음): {p.name}")
                continue
            with fitz.open(p) as d:
                scan_text(p.name, "\n".join(pg.get_text() for pg in d), hits)
            n += 1
    for h in hits:
        print("발견:", h)
    print(f"검사한 파일 {n}개, 발견 {len(hits)}건")
    return 1 if hits else 0


if __name__ == "__main__":
    sys.exit(main())
