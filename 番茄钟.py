"""
🍅 桌面番茄钟 - Pomodoro Timer
一个功能完整的番茄钟桌面应用
"""

import tkinter as tk
from tkinter import ttk, messagebox
import time
import threading
import winsound
import json
import os
from datetime import datetime
from math import pi, sin, cos

# ========== 配置 ==========
CONFIG_FILE = "pomodoro_config.json"

DEFAULT_CONFIG = {
    "work_time": 25 * 60,       # 工作时间（秒）
    "short_break": 5 * 60,      # 短休息（秒）
    "long_break": 15 * 60,      # 长休息（秒）
    "long_break_interval": 4,   # 每几个番茄钟后长休息
    "daily_goal": 8,            # 每日目标番茄数
    "auto_start_break": False,  # 完成后自动开始休息
    "sound_enabled": True,      # 启用声音
    "stay_on_top": False,       # 窗口置顶
}

class PomodoroApp:
    def __init__(self, root):
        self.root = root
        self.root.title("🍅 番茄钟")
        self.root.geometry("420x580")
        self.root.resizable(False, False)
        self.root.configure(bg="#1a1a2e")

        # 加载配置
        self.config = self.load_config()

        # 状态变量
        self.state = "idle"        # idle, working, short_break, long_break
        self.time_left = self.config["work_time"]
        self.is_running = False
        self.is_paused = False
        self.pomodoro_count = 0
        self.today_count = self.load_today_count()
        self.current_phase = "work"

        # 颜色方案
        self.colors = {
            "bg": "#1a1a2e",
            "card": "#16213e",
            "accent": "#e94560",
            "accent2": "#0f3460",
            "text": "#ffffff",
            "text_secondary": "#a0a0b0",
            "success": "#4ecca3",
            "warning": "#ffc93c",
        }

        # 设置窗口置顶
        if self.config["stay_on_top"]:
            self.root.attributes("-topmost", True)

        # 加载图标
        try:
            self.root.iconbitmap(default="")
        except:
            pass

        self.setup_ui()
        self.update_display()

        # 绑定键盘快捷键
        self.root.bind("<space>", lambda e: self.toggle_timer())
        self.root.bind("<r>", lambda e: self.reset_timer())
        self.root.bind("<Escape>", lambda e: self.root.quit())
        self.root.bind("<Configure>", self.on_window_configure)

        # 窗口居中
        self.center_window()

        # 定时更新显示
        self.update_clock()

        # 保存日统计的定时器
        self.schedule_daily_reset_check()

    def center_window(self):
        """窗口居中"""
        self.root.update_idletasks()
        w = self.root.winfo_width()
        h = self.root.winfo_height()
        ws = self.root.winfo_screenwidth()
        hs = self.root.winfo_screenheight()
        x = (ws - w) // 2
        y = (hs - h) // 2
        self.root.geometry(f"{w}x{h}+{x}+{y}")

    def setup_ui(self):
        """构建UI"""
        # 主容器
        self.main_frame = tk.Frame(self.root, bg=self.colors["bg"])
        self.main_frame.pack(fill=tk.BOTH, expand=True, padx=20, pady=20)

        # === 顶部：标题和统计 ===
        self.header_frame = tk.Frame(self.main_frame, bg=self.colors["bg"])
        self.header_frame.pack(fill=tk.X, pady=(0, 10))

        # 标题
        self.title_label = tk.Label(
            self.header_frame,
            text="🍅 番茄钟",
            font=("Segoe UI", 18, "bold"),
            bg=self.colors["bg"],
            fg=self.colors["text"],
        )
        self.title_label.pack(side=tk.LEFT)

        # 今日统计
        self.stats_frame = tk.Frame(self.header_frame, bg=self.colors["bg"])
        self.stats_frame.pack(side=tk.RIGHT)

        self.goal_label = tk.Label(
            self.stats_frame,
            text=f"今日 0/{self.config['daily_goal']} 🎯",
            font=("Segoe UI", 11),
            bg=self.colors["bg"],
            fg=self.colors["text_secondary"],
        )
        self.goal_label.pack()

        # === 中间：计时器 ===
        self.timer_frame = tk.Frame(self.main_frame, bg=self.colors["bg"])
        self.timer_frame.pack(fill=tk.BOTH, expand=True, pady=10)

        # 画布 - 圆形计时器
        self.canvas_size = 280
        self.canvas = tk.Canvas(
            self.timer_frame,
            width=self.canvas_size,
            height=self.canvas_size,
            bg=self.colors["bg"],
            highlightthickness=0,
        )
        self.canvas.pack()

        # 绘制静态圆环
        self.draw_timer_canvas()

        # === 底部：控制按钮 ===
        self.control_frame = tk.Frame(self.main_frame, bg=self.colors["bg"])
        self.control_frame.pack(fill=tk.X, pady=(10, 5))

        # 按钮样式
        self.btn_style = {
            "font": ("Segoe UI", 12, "bold"),
            "bd": 0,
            "cursor": "hand2",
            "relief": tk.FLAT,
        }

        btn_frame = tk.Frame(self.control_frame, bg=self.colors["bg"])
        btn_frame.pack()

        self.start_btn = self.create_button(
            btn_frame, "▶ 开始", self.toggle_timer,
            bg=self.colors["accent"], fg="#ffffff",
            width=10,
        )
        self.start_btn.pack(side=tk.LEFT, padx=5)

        self.reset_btn = self.create_button(
            btn_frame, "↺ 重置", self.reset_timer,
            bg=self.colors["accent2"], fg="#ffffff",
            width=10,
        )
        self.reset_btn.pack(side=tk.LEFT, padx=5)

        self.settings_btn = self.create_button(
            btn_frame, "⚙ 设置", self.open_settings,
            bg=self.colors["accent2"], fg="#ffffff",
            width=10,
        )
        self.settings_btn.pack(side=tk.LEFT, padx=5)

        # === 模式切换 ===
        self.mode_frame = tk.Frame(self.main_frame, bg=self.colors["bg"])
        self.mode_frame.pack(fill=tk.X, pady=(10, 0))

        self.mode_var = tk.StringVar(value="work")
        modes = [
            ("🍅 工作", "work"),
            ("☕ 短休", "short_break"),
            ("🌙 长休", "long_break"),
        ]

        for i, (text, mode) in enumerate(modes):
            btn = tk.Radiobutton(
                self.mode_frame,
                text=text,
                variable=self.mode_var,
                value=mode,
                command=self.switch_mode,
                font=("Segoe UI", 10),
                bg=self.colors["bg"],
                fg=self.colors["text_secondary"],
                selectcolor=self.colors["bg"],
                activebackground=self.colors["bg"],
                activeforeground=self.colors["text"],
                highlightthickness=0,
                bd=0,
                padx=10,
            )
            btn.pack(side=tk.LEFT, expand=True)

        # === 进度条：番茄计数 ===
        self.progress_frame = tk.Frame(self.main_frame, bg=self.colors["bg"])
        self.progress_frame.pack(fill=tk.X, pady=(10, 0))

        self.progress_label = tk.Label(
            self.progress_frame,
            text="今日进度",
            font=("Segoe UI", 9),
            bg=self.colors["bg"],
            fg=self.colors["text_secondary"],
        )
        self.progress_label.pack(anchor=tk.W)

        # 进度条
        self.progress = ttk.Progressbar(
            self.progress_frame,
            length=380,
            mode="determinate",
            style="TProgressbar",
        )
        self.progress.pack(pady=(5, 0))
        self.update_progress_bar()

        # === 状态提示 ===
        self.status_label = tk.Label(
            self.main_frame,
            text="准备开始 🍅",
            font=("Segoe UI", 10),
            bg=self.colors["bg"],
            fg=self.colors["text_secondary"],
        )
        self.status_label.pack(pady=(10, 0))

        # 配置 ttk 样式
        self.setup_styles()

    def setup_styles(self):
        """配置 ttk 样式"""
        style = ttk.Style()
        style.theme_use("clam")
        style.configure(
            "TProgressbar",
            background=self.colors["success"],
            troughcolor=self.colors["card"],
            bordercolor=self.colors["card"],
            lightcolor=self.colors["success"],
            darkcolor=self.colors["success"],
            thickness=8,
        )

    def create_button(self, parent, text, command, bg="#333", fg="#fff", width=8):
        """创建自定义按钮"""
        btn = tk.Button(
            parent,
            text=text,
            command=command,
            bg=bg,
            fg=fg,
            width=width,
            **self.btn_style,
        )

        # 悬停效果
        def on_enter(e):
            btn["bg"] = self.lighten_color(bg, 0.3)

        def on_leave(e):
            btn["bg"] = bg

        btn.bind("<Enter>", on_enter)
        btn.bind("<Leave>", on_leave)
        return btn

    def lighten_color(self, color, factor=0.3):
        """使颜色变亮"""
        # 简单处理命名颜色
        if color == self.colors["accent"]:
            return "#ff6b81"
        elif color == self.colors["accent2"]:
            return "#1a4a7a"
        return color

    def draw_timer_canvas(self):
        """绘制圆形计时器"""
        self.canvas.delete("all")
        cx = cy = self.canvas_size // 2
        r = 110  # 半径
        width = 10

        # 背景圆环
        self.canvas.create_oval(
            cx - r, cy - r, cx + r, cy + r,
            outline=self.colors["card"],
            width=width,
        )

        # 进度圆环（初始为空）
        self.progress_arc = self.canvas.create_arc(
            cx - r, cy - r, cx + r, cy + r,
            start=90, extent=0,
            outline=self.colors["accent"],
            width=width,
            style=tk.ARC,
        )

        # 时间文字
        self.time_text = self.canvas.create_text(
            cx, cy - 15,
            text="25:00",
            font=("Segoe UI", 42, "bold"),
            fill=self.colors["text"],
        )

        # 阶段文字
        self.phase_text = self.canvas.create_text(
            cx, cy + 35,
            text="🍅 工作时间",
            font=("Segoe UI", 13),
            fill=self.colors["text_secondary"],
        )

    def update_display(self):
        """更新显示"""
        total = self.get_current_total_time()
        elapsed = total - self.time_left
        progress = elapsed / total if total > 0 else 0

        # 更新时间文字
        minutes = self.time_left // 60
        seconds = self.time_left % 60
        time_str = f"{minutes:02d}:{seconds:02d}"
        self.canvas.itemconfig(self.time_text, text=time_str)

        # 更新进度圆环
        extent = -progress * 360  # 顺时针
        color = self.get_phase_color()
        self.canvas.itemconfig(self.progress_arc, extent=extent, outline=color)

        # 更新阶段文字
        phase_icons = {
            "work": "🍅",
            "short_break": "☕",
            "long_break": "🌙",
        }
        phase_names = {
            "work": "工作时间",
            "short_break": "短休息",
            "long_break": "长休息",
        }
        icon = phase_icons.get(self.current_phase, "🍅")
        name = phase_names.get(self.current_phase, "未知")

        self.canvas.itemconfig(
            self.phase_text,
            text=f"{icon} {name}",
            fill=color,
        )

        # 更新目标显示
        self.goal_label.config(
            text=f"今日 {self.today_count}/{self.config['daily_goal']} 🎯"
        )

        # 更新进度条
        self.update_progress_bar()

        # 更新状态栏
        if self.is_paused:
            self.status_label.config(text="⏸ 已暂停", fg=self.colors["warning"])
        elif self.is_running:
            self.status_label.config(text=f"⏳ 进行中... 已完成本日 {self.today_count} 个番茄", fg=color)
        else:
            self.status_label.config(text="准备开始 🍅", fg=self.colors["text_secondary"])

        # 更新窗口标题
        if self.is_running:
            self.root.title(f"🍅 {time_str} - 番茄钟")
        else:
            self.root.title("🍅 番茄钟")

    def update_progress_bar(self):
        """更新进度条"""
        if self.config["daily_goal"] > 0:
            pct = min(1.0, self.today_count / self.config["daily_goal"])
            self.progress["value"] = pct * 100

    def get_current_total_time(self):
        """获取当前阶段的总时长"""
        if self.current_phase == "work":
            return self.config["work_time"]
        elif self.current_phase == "short_break":
            return self.config["short_break"]
        else:
            return self.config["long_break"]

    def get_phase_color(self):
        """获取当前阶段的颜色"""
        if self.current_phase == "work":
            return self.colors["accent"]
        elif self.current_phase == "short_break":
            return self.colors["success"]
        else:
            return self.colors["warning"]

    def toggle_timer(self):
        """切换开始/暂停"""
        if not self.is_running:
            self.start_timer()
        else:
            self.pause_timer()

    def start_timer(self):
        """开始计时"""
        if self.time_left <= 0:
            self.reset_timer()

        self.is_running = True
        self.is_paused = False
        self.start_btn.config(text="⏸ 暂停", bg=self.colors["warning"])
        self.update_display()

        # 启动计时线程
        self.timer_thread = threading.Thread(target=self.run_timer, daemon=True)
        self.timer_thread.start()

    def run_timer(self):
        """计时器主循环"""
        while self.is_running and self.time_left > 0:
            if not self.is_paused:
                time.sleep(1)
                self.time_left -= 1
                self.root.after(0, self.update_display)
            else:
                time.sleep(0.1)

        if self.time_left <= 0 and self.is_running:
            self.is_running = False
            self.root.after(0, self.on_timer_complete)

    def pause_timer(self):
        """暂停计时"""
        self.is_paused = True
        self.start_btn.config(text="▶ 继续", bg=self.colors["accent"])
        self.update_display()

    def reset_timer(self):
        """重置计时器"""
        self.is_running = False
        self.is_paused = False
        self.time_left = self.get_current_total_time()
        self.start_btn.config(text="▶ 开始", bg=self.colors["accent"])
        self.update_display()

    def switch_mode(self):
        """切换工作/休息模式"""
        if self.is_running:
            if not messagebox.askyesno("切换模式", "计时正在进行中，确定要切换吗？"):
                self.mode_var.set(self.current_phase)
                return

        self.is_running = False
        self.is_paused = False
        self.current_phase = self.mode_var.get()
        self.time_left = self.get_current_total_time()
        self.start_btn.config(text="▶ 开始", bg=self.colors["accent"])
        self.update_display()

    def on_timer_complete(self):
        """计时完成时的处理"""
        if self.current_phase == "work":
            self.today_count += 1
            self.save_today_count()
            self.pomodoro_count += 1

            # 播放声音
            if self.config["sound_enabled"]:
                self.play_sound()

            # 判断是短休还是长休
            if self.pomodoro_count % self.config["long_break_interval"] == 0:
                next_phase = "long_break"
                phase_name = "长休息"
            else:
                next_phase = "short_break"
                phase_name = "短休息"

            messagebox.showinfo(
                "🍅 番茄完成！",
                f"太棒了！完成第 {self.today_count} 个番茄！\n\n接下来: {phase_name} 🌙"
            )

            if self.config["auto_start_break"]:
                self.current_phase = next_phase
                self.mode_var.set(next_phase)
                self.time_left = self.get_current_total_time()
                self.start_timer()
            else:
                self.current_phase = next_phase
                self.mode_var.set(next_phase)
                self.time_left = self.get_current_total_time()
                self.start_btn.config(text="▶ 开始", bg=self.colors["accent"])

        else:
            # 休息结束
            if self.config["sound_enabled"]:
                self.play_sound()

            messagebox.showinfo(
                "☕ 休息结束",
                "休息时间到！准备开始下一个番茄吧 🍅"
            )

            self.current_phase = "work"
            self.mode_var.set("work")
            self.time_left = self.config["work_time"]
            self.start_btn.config(text="▶ 开始", bg=self.colors["accent"])

        self.update_display()

    def play_sound(self):
        """播放提示音"""
        try:
            # Windows 系统声音
            winsound.PlaySound("SystemExclamation", winsound.SND_ALIAS)
        except:
            try:
                # 备用方案：蜂鸣
                winsound.Beep(880, 300)
                winsound.Beep(660, 300)
                winsound.Beep(880, 600)
            except:
                pass  # 无声回退

    def update_clock(self):
        """周期性更新显示（处理暂停状态）"""
        if not self.is_running:
            self.update_display()
        self.root.after(1000, self.update_clock)

    def schedule_daily_reset_check(self):
        """检查是否需要重置日计数"""
        # 每 60 秒检查一次
        self.root.after(60000, self.check_daily_reset)

    def check_daily_reset(self):
        """检查日期变更"""
        today = datetime.now().strftime("%Y-%m-%d")
        saved_date = self.load_saved_date()

        if saved_date != today:
            self.today_count = 0
            self.save_today_count()

        self.schedule_daily_reset_check()

    def on_window_configure(self, event):
        """窗口配置变化时"""
        pass

    # ========== 设置界面 ==========
    def open_settings(self):
        """打开设置窗口"""
        SettingsWindow(self)

    # ========== 持久化 ==========
    def load_config(self):
        """加载配置"""
        try:
            if os.path.exists(CONFIG_FILE):
                with open(CONFIG_FILE, "r", encoding="utf-8") as f:
                    loaded = json.load(f)
                    config = DEFAULT_CONFIG.copy()
                    config.update(loaded)
                    return config
        except:
            pass
        return DEFAULT_CONFIG.copy()

    def save_config(self):
        """保存配置"""
        try:
            with open(CONFIG_FILE, "w", encoding="utf-8") as f:
                json.dump(self.config, f, ensure_ascii=False, indent=2)
        except:
            pass

    def load_today_count(self):
        """加载今日番茄数"""
        try:
            today = datetime.now().strftime("%Y-%m-%d")
            if os.path.exists("pomodoro_stats.json"):
                with open("pomodoro_stats.json", "r", encoding="utf-8") as f:
                    data = json.load(f)
                    if data.get("date") == today:
                        return data.get("count", 0)
        except:
            pass
        return 0

    def save_today_count(self):
        """保存今日番茄数"""
        try:
            today = datetime.now().strftime("%Y-%m-%d")
            with open("pomodoro_stats.json", "w", encoding="utf-8") as f:
                json.dump({"date": today, "count": self.today_count}, f)
        except:
            pass

    def load_saved_date(self):
        """获取已保存的日期"""
        try:
            if os.path.exists("pomodoro_stats.json"):
                with open("pomodoro_stats.json", "r", encoding="utf-8") as f:
                    data = json.load(f)
                    return data.get("date", "")
        except:
            pass
        return ""


# ========== 设置窗口 ==========
class SettingsWindow:
    def __init__(self, app):
        self.app = app
        self.window = tk.Toplevel(app.root)
        self.window.title("⚙ 番茄钟设置")
        self.window.geometry("400x450")
        self.window.resizable(False, False)
        self.window.configure(bg=app.colors["bg"])
        self.window.transient(app.root)
        self.window.grab_set()

        # 居中
        self.window.update_idletasks()
        w = self.window.winfo_width()
        h = self.window.winfo_height()
        ws = self.window.winfo_screenwidth()
        hs = self.window.winfo_screenheight()
        x = (ws - w) // 2
        y = (hs - h) // 2
        self.window.geometry(f"{w}x{h}+{x}+{y}")

        self.setup_ui()

    def setup_ui(self):
        """构建设置界面"""
        c = self.app.colors

        main = tk.Frame(self.window, bg=c["bg"], padx=25, pady=20)
        main.pack(fill=tk.BOTH, expand=True)

        # 标题
        tk.Label(
            main,
            text="⚙ 设置",
            font=("Segoe UI", 16, "bold"),
            bg=c["bg"],
            fg=c["text"],
        ).pack(anchor=tk.W, pady=(0, 15))

        # 时间设置
        self.add_section_title(main, "⏱ 时间设置（分钟）")

        time_frame = tk.Frame(main, bg=c["bg"])
        time_frame.pack(fill=tk.X, pady=(5, 15))

        fields = [
            ("工作时间", "work_time", 25),
            ("短休息", "short_break", 5),
            ("长休息", "long_break", 15),
        ]

        self.time_vars = {}
        for i, (label, key, default) in enumerate(fields):
            tk.Label(time_frame, text=label, font=("Segoe UI", 10),
                     bg=c["bg"], fg=c["text_secondary"]).grid(row=i, column=0, sticky=tk.W, pady=3)

            var = tk.StringVar(value=str(self.app.config[key] // 60))
            self.time_vars[key] = var
            entry = tk.Entry(time_frame, textvariable=var, width=5,
                             font=("Segoe UI", 11), bd=1, relief=tk.SOLID,
                             bg=c["card"], fg=c["text"], insertbackground=c["text"])
            entry.grid(row=i, column=1, padx=(10, 5), pady=3)

            tk.Label(time_frame, text="分钟", font=("Segoe UI", 10),
                     bg=c["bg"], fg=c["text_secondary"]).grid(row=i, column=2, sticky=tk.W, pady=3)

        # 其他设置
        self.add_section_title(main, "📋 其他设置")

        # 长休息间隔
        interval_frame = tk.Frame(main, bg=c["bg"])
        interval_frame.pack(fill=tk.X, pady=5)

        tk.Label(interval_frame, text="长休息间隔（番茄数）",
                 font=("Segoe UI", 10), bg=c["bg"], fg=c["text_secondary"]).pack(side=tk.LEFT)

        self.interval_var = tk.StringVar(value=str(self.app.config["long_break_interval"]))
        entry = tk.Entry(interval_frame, textvariable=self.interval_var, width=5,
                         font=("Segoe UI", 11), bd=1, relief=tk.SOLID,
                         bg=c["card"], fg=c["text"], insertbackground=c["text"])
        entry.pack(side=tk.RIGHT)

        # 每日目标
        goal_frame = tk.Frame(main, bg=c["bg"])
        goal_frame.pack(fill=tk.X, pady=5)

        tk.Label(goal_frame, text="每日目标番茄数",
                 font=("Segoe UI", 10), bg=c["bg"], fg=c["text_secondary"]).pack(side=tk.LEFT)

        self.goal_var = tk.StringVar(value=str(self.app.config["daily_goal"]))
        entry = tk.Entry(goal_frame, textvariable=self.goal_var, width=5,
                         font=("Segoe UI", 11), bd=1, relief=tk.SOLID,
                         bg=c["card"], fg=c["text"], insertbackground=c["text"])
        entry.pack(side=tk.RIGHT)

        # 复选框选项
        self.check_vars = {}
        checks = [
            ("auto_start_break", "自动开始休息"),
            ("sound_enabled", "启用提示音"),
            ("stay_on_top", "窗口置顶"),
        ]

        for key, text in checks:
            var = tk.BooleanVar(value=self.app.config[key])
            self.check_vars[key] = var
            cb = tk.Checkbutton(
                main, text=text, variable=var,
                font=("Segoe UI", 10), bg=c["bg"], fg=c["text_secondary"],
                selectcolor=c["bg"], activebackground=c["bg"],
                activeforeground=c["text"], highlightthickness=0, bd=0,
                padx=5,
            )
            cb.pack(anchor=tk.W, pady=3)

        # 按钮
        btn_frame = tk.Frame(main, bg=c["bg"])
        btn_frame.pack(fill=tk.X, pady=(20, 0))

        tk.Button(
            btn_frame, text="保存",
            command=self.save_settings,
            font=("Segoe UI", 11, "bold"),
            bg=c["accent"], fg="#ffffff",
            bd=0, padx=20, pady=5, cursor="hand2",
        ).pack(side=tk.RIGHT, padx=(5, 0))

        tk.Button(
            btn_frame, text="取消",
            command=self.window.destroy,
            font=("Segoe UI", 11),
            bg=c["accent2"], fg="#ffffff",
            bd=0, padx=20, pady=5, cursor="hand2",
        ).pack(side=tk.RIGHT)

    def add_section_title(self, parent, text):
        """添加分区标题"""
        tk.Label(
            parent, text=text,
            font=("Segoe UI", 11, "bold"),
            bg=self.app.colors["bg"],
            fg=self.app.colors["text"],
        ).pack(anchor=tk.W, pady=(10, 0))

    def save_settings(self):
        """保存设置"""
        try:
            # 验证并保存时间设置
            for key in ["work_time", "short_break", "long_break"]:
                val = int(self.time_vars[key].get())
                if val < 1:
                    raise ValueError(f"{key} 必须大于0")
                self.app.config[key] = val * 60

            # 验证其他整数设置
            interval = int(self.interval_var.get())
            if interval < 1:
                raise ValueError("长休息间隔必须大于0")
            self.app.config["long_break_interval"] = interval

            goal = int(self.goal_var.get())
            if goal < 1:
                raise ValueError("每日目标必须大于0")
            self.app.config["daily_goal"] = goal

            # 保存复选框
            for key in ["auto_start_break", "sound_enabled", "stay_on_top"]:
                self.app.config[key] = self.check_vars[key].get()

            # 应用置顶设置
            self.app.root.attributes("-topmost", self.app.config["stay_on_top"])

            # 保存配置
            self.app.save_config()

            # 重置计时器（如果不在运行中）
            if not self.app.is_running:
                self.app.time_left = self.app.get_current_total_time()
                self.app.update_display()

            self.window.destroy()
            messagebox.showinfo("设置", "设置已保存 ✅")

        except ValueError as e:
            messagebox.showerror("输入错误", str(e))
        except:
            messagebox.showerror("错误", "请输入有效的数字")


# ========== 入口 ==========
if __name__ == "__main__":
    root = tk.Tk()
    app = PomodoroApp(root)

    # 设置关闭事件
    def on_closing():
        if app.is_running:
            if messagebox.askyesno("退出", "计时正在进行中，确定要退出吗？"):
                root.destroy()
        else:
            root.destroy()

    root.protocol("WM_DELETE_WINDOW", on_closing)
    root.mainloop()