#!/usr/bin/env bash

export LC_ALL=C
TOPDIR=${TOPDIR:-$(git rev-parse --show-toplevel)}
BUILDDIR=${BUILDDIR:-$TOPDIR}

BINDIR=${BINDIR:-$BUILDDIR/src}
MANDIR=${MANDIR:-$TOPDIR/doc/man}

BITCOIND=${BITCOIND:-$BINDIR/merdecoind}
BITCOINCLI=${BITCOINCLI:-$BINDIR/merdecoin-cli}
BITCOINTX=${BITCOINTX:-$BINDIR/merdecoin-tx}
WALLET_TOOL=${WALLET_TOOL:-$BINDIR/merdecoin-wallet}
BITCOINQT=${BITCOINQT:-$BINDIR/qt/merdecoin-qt}

[ ! -x $BITCOIND ] && echo "$BITCOIND not found or not executable." && exit 1

# The autodetected version git tag can screw up manpage output a little bit
read -r -a MRDVER <<< "$($BITCOINCLI --version | head -n1 | awk -F'[ -]' '{ print $6, $7 }')"

# Create a footer file with copyright content.
# This gets autodetected fine for merdecoind if --version-string is not set,
# but has different outcomes for merdecoin-qt and merdecoin-cli.
echo "[COPYRIGHT]" > footer.h2m
$BITCOIND --version | sed -n '1!p' >> footer.h2m

for cmd in $BITCOIND $BITCOINCLI $BITCOINTX $WALLET_TOOL $BITCOINQT; do
  cmdname="${cmd##*/}"
  help2man -N --version-string=${MRDVER[0]} --include=footer.h2m -o ${MANDIR}/${cmdname}.1 ${cmd}
  sed -i "s/\\\-${MRDVER[1]}//g" ${MANDIR}/${cmdname}.1
done

rm -f footer.h2m
