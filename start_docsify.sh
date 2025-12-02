#!/bin/bash

# 获取脚本所在目录并进入
cd "$(dirname "$0")"

# 定义端口
PORT=3001

# 检查端口是否被占用，如果是则杀掉进程
# lsof 可能在某些极简 Linux 发行版中未安装，但在 macOS 上通常可用
if command -v lsof &>/dev/null; then
    PID=$(lsof -ti :$PORT)
    if [ -n "$PID" ]; then
        echo "Port $PORT is in use (PID: $PID), killing process..."
        kill -9 $PID
    fi
fi

# 检查 python3 是否存在
if command -v python3 &>/dev/null; then
    PYTHON_CMD="python3"
elif command -v python &>/dev/null; then
    # 检查版本是否为 3.x
    if python -c 'import sys; exit(0) if sys.version_info.major == 3 else exit(1)'; then
        PYTHON_CMD="python"
    else
        echo "Error: Python 3 not found. Please install Python 3."
        exit 1
    fi
else
    echo "Error: Python not found. Please install Python 3."
    exit 1
fi

echo "Starting Docsify server..."
echo "Address: http://localhost:$PORT/#/"
echo "Press Ctrl+C to stop"

# 启动服务器（后台运行，以便执行打开浏览器的命令）
$PYTHON_CMD service.py >/dev/null 2>&1 &
SERVER_PID=$!

# 捕获 Ctrl+C 信号，以便优雅退出并关闭服务器进程
trap "kill $SERVER_PID; exit" SIGINT SIGTERM

# 等待一秒确保服务器启动
sleep 1

# 根据操作系统打开浏览器
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    open "http://localhost:$PORT/#/"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    if command -v xdg-open &>/dev/null; then
        xdg-open "http://localhost:$PORT/#/"
    fi
fi

# 等待服务器进程结束
wait $SERVER_PID