#
# Copyright 2016-2021, Cypress Semiconductor Corporation (an Infineon company) or
# an affiliate of Cypress Semiconductor Corporation.  All rights reserved.
#
# This software, including source code, documentation and related
# materials ("Software") is owned by Cypress Semiconductor Corporation
# or one of its affiliates ("Cypress") and is protected by and subject to
# worldwide patent protection (United States and foreign),
# United States copyright laws and international treaty provisions.
# Therefore, you may use this Software only as provided in the license
# agreement accompanying the software package from which you
# obtained this Software ("EULA").
# If no EULA applies, Cypress hereby grants you a personal, non-exclusive,
# non-transferable license to copy, modify, and compile the Software
# source code solely for use in connection with Cypress's
# integrated circuit products.  Any reproduction, modification, translation,
# compilation, or representation of this Software except as specified
# above is prohibited without the express written permission of Cypress.
#
# Disclaimer: THIS SOFTWARE IS PROVIDED AS-IS, WITH NO WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, NONINFRINGEMENT, IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. Cypress
# reserves the right to make changes to the Software without notice. Cypress
# does not assume any liability arising out of the application or use of the
# Software or any product or circuit described in the Software. Cypress does
# not authorize its products for use in any products where a malfunction or
# failure of the Cypress product may reasonably be expected to result in
# significant property damage, injury or death ("High Risk Product"). By
# including Cypress's product in a High Risk Product, the manufacturer
# of such system or application assumes all risk of such use and in doing
# so agrees to indemnify Cypress against all liability.
#

ifeq ($(WHICHFILE),true)
$(info Processing $(lastword $(MAKEFILE_LIST)))
endif

#
# Basic Configuration
#
APPNAME=WICED SDK Tools

################################################################################
# Paths
################################################################################

# Path (absolute or relative) to the project
CY_APP_PATH=.

# Relative path to the shared repo location.
#
# All .mtb files have the format, <URI><COMMIT><LOCATION>. If the <LOCATION> field
# begins with $$ASSET_REPO$$, then the repo is deposited in the path specified by
# the CY_GETLIBS_SHARED_PATH variable. The default location is one directory level
# above the current app directory.
# This is used with CY_GETLIBS_SHARED_NAME variable, which specifies the directory name.
CY_GETLIBS_SHARED_PATH=../

# Directory name of the shared repo location.
#
CY_GETLIBS_SHARED_NAME=mtb_shared

# Absolute path to the compiler (Default: GCC in the tools)
CY_COMPILER_PATH=

# Locate ModusToolbox IDE helper tools folders in default installation
# locations for Windows, Linux, and macOS.
CY_WIN_HOME=$(subst \,/,$(USERPROFILE))
CY_TOOLS_PATHS ?= $(wildcard \
    $(CY_WIN_HOME)/ModusToolbox/tools_* \
    $(HOME)/ModusToolbox/tools_* \
    /Applications/ModusToolbox/tools_* \
    $(CY_IDE_TOOLS_DIR))

# If you install ModusToolbox IDE in a custom location, add the path to its
# "tools_X.Y" folder (where X and Y are the version number of the tools
# folder).
CY_TOOLS_PATHS+=

# Default to the newest installed tools folder, or the users override (if it's
# found).
CY_TOOLS_DIR=$(lastword $(sort $(wildcard $(CY_TOOLS_PATHS))))

ifeq ($(CY_TOOLS_DIR),)
$(error Unable to find any of the available CY_TOOLS_PATHS -- $(CY_TOOLS_PATHS))
endif

LIBRARY_BUILD_GOALS:=build clean program qprogram all

ifeq ($(filter $(LIBRARY_BUILD_GOALS),$(MAKECMDGOALS)),)

TOOLCHAIN=GCC_ARM
TARGET=CYW920819EVB-02
CY_SHARED_PATH=.
CY_SHARED_PATH_ABS=$(CURDIR)

SUPPORTED_TARGETS = \
  CYW920819EVB-02 \
  CYW920820EVB-02 \
  CYBT-213043-EVAL \
  CYBT-243053-EVAL \
  CYBT-253059-EVAL \
  CYBT-223058-EVAL \
  CYBT-273063-EVAL \
  CYBT-263065-EVAL \
  CYW989820EVB-01 \
  CYW920721B2EVK-03 \
  CYW920721B2EVK-02 \
  CYW920719B2Q40EVB-01 \
  CYW920706WCDEVAL \
  CYBT-353027-EVAL \
  CYBT-343026-EVAL \
  CYW920735Q60EVB-01 \
  CYW9M2BASE-43012BT \
  CYBT-423054-EVAL \
  CYBT-413055-EVAL \
  CYBT-483056-EVAL \
  CYBT-213043-MESH \
  CYW920835REF-RCU-01 \
  CYBT-423060-EVAL \
  CYBT-413061-EVAL \
  CYBT-483062-EVAL \
  CYW920819REF-KB-01 \
  CYW920721M2EVK-01 \
  CYW920721M2EVK-02 \
  CYW943012BTEVK-01

TARGET_DEVICE_MAP = \
  CYW920819EVB-02/20819A1 \
  CYW920819REF-KB-01/20819A1 \
  CYW920819REF-MS-01/20819A1 \
  CYW920819REF-RM-01/20819A1 \
  CYW920820EVB-02/20820A1 \
  CYBT-213043-EVAL/20819A1 \
  CYBT-243053-EVAL/20820A1 \
  CYBT-253059-EVAL/20820A1 \
  CYBT-223058-EVAL/20819A1 \
  CYBT-273063-EVAL/20819A1 \
  CYBT-263065-EVAL/20819A1 \
  CYW989820EVB-01/20820A1 \
  CYW920721B2EVK-03/20721B2 \
  CYW920721B2EVK-02/20721B2 \
  CYW920721M2EVK-02/20721B2 \
  CYW920721M2EVK-01/20721B2 \
  CYW920719B2Q40EVB-01/20719B2 \
  CYW920706WCDEVAL/20706A2 \
  CYBT-353027-EVAL/20706A2 \
  CYBT-343026-EVAL/20706A2 \
  CYW920735Q60EVB-01/20735B1 \
  CYW9M2BASE-43012BT/43012C0 \
  CYBT-423054-EVAL/20719B2 \
  CYBT-413055-EVAL/20719B2 \
  CYBT-483056-EVAL/20719B2 \
  CYBT-213043-MESH/20819A1 \
  CYW920835REF-RCU-01/20835B1 \
  CYBT-423060-EVAL/20721B2 \
  CYBT-413061-EVAL/20721B2 \
  CYBT-483062-EVAL/20721B2 \
  CYW943012BTEVK-01/43012C0 \

CY_TARGET_DEVICE = $(patsubst $(TARGET)/%,%,$(filter $(TARGET)%,$(TARGET_DEVICE_MAP)))
ifeq ($(CY_TARGET_DEVICE),)
$(error Could not determine device baselib from TARGET: $(TARGET))
endif

# make device-configurator not show up
override CY_CONFIG_MODUS_EXT=notmodus

# tools that can be launched with "make open CY_OPEN_TYPE=<tool>
CY_BT_APP_TOOLS=BTSpy ClientControl
CY_BT_APP_TOOLS+=ClientControlMesh MeshClient
CY_BT_APP_TOOLS+=hello_client
#CY_BT_APP_TOOLS+=WsOtaUpgrade
#CY_BT_APP_TOOLS+=WMBT ecdsa_genkey ecdsa_sign ecdsa_verify

include $(CY_TOOLS_DIR)/make/start.mk
else

$(LIBRARY_BUILD_GOALS):
	@echo This is not a buildable project. It is a project used to download all tools.
	@echo \"make $@\" : Success

-include internal.mk
endif
