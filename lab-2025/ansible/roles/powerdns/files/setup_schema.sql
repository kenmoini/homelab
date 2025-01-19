#!/bin/bash

mysql $mysql_flags < schema.sql
mysql $mysql_flags < enable_fkeys.sql