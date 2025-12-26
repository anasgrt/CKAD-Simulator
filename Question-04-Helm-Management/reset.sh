#!/bin/bash
echo "[RESET] Cleaning up Question 4..."
helm -n mercury uninstall internal-issue-report-apiv1 2>/dev/null || true
helm -n mercury uninstall internal-issue-report-apiv2 2>/dev/null || true
helm -n mercury uninstall internal-issue-report-app 2>/dev/null || true
helm -n mercury uninstall internal-issue-report-apache 2>/dev/null || true
echo "[RESET] Done!"
