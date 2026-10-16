# SPDX-FileCopyrightText: © 2025 Clifford Weinmann <https://www.cliffordweinmann.com/>
# SPDX-License-Identifier: MIT-0

# FROM registry.access.redhat.com/ubi10/ubi:10.2-1791894362
# RUN dnf install -y rsync
FROM registry.access.redhat.com/ubi10/ubi-minimal:10.2-1791891203
RUN microdnf install -y rsync
