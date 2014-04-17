#!/bin/sh

euscan -q `EIX_LIMIT=0 eix --in-overlay pimvullers --only-names`
