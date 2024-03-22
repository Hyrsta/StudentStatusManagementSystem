@echo off
setlocal

:: 进入 backend 目录并执行 node main.js
cd ./backend/
start node main.js

:: 等待 5 秒钟
timeout /nobreak /t 5

:: 返回批处理脚本文件的位置
cd ..

:: 进入 frontend 目录并执行 npm run dev
cd ./frontend/
npm run dev

:: 返回批处理脚本文件的位置
cd ..

echo 操作完成

endlocal
