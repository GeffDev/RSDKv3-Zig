pub const std = @import("std");
pub const c = @import("c.zig");

pub const drawing = @import("Drawing.zig");
pub const math = @import("Math.zig");

pub const RetroLanguages = enum {
    RETRO_EN,
    RETRO_FR,
    RETRO_IT,
    RETRO_DE,
    RETRO_ES,
    RETRO_JP,
};

pub const RetroStates = enum {
    ENGINE_DEVMENU,
    ENGINE_MAINGAME,
    ENGINE_INITDEVMENU,
    ENGINE_EXITGAME,
    ENGINE_SCRIPTERROR,
    ENGINE_ENTER_HIRESMODE,
    ENGINE_EXIT_HIRESMODE,
    ENGINE_PAUSE,
    ENGINE_WAIT,
    ENGINE_VIDEOWAIT,
};

pub const RetroRenderTypes = enum {
    RENDER_SW,
    RENDER_HW,
};

pub const RetroBytecodeFormat = enum { BYTECODE_MOBILE, BYTECODE_PC };

pub const screenYSize = 240;
pub const screenCenterY = screenYSize / 2;

pub const RetroEngine = struct {
    pub const rand = std.rand.DefaultPrng.init(std.time.timestamp());

    pub var usingDataFileConfig: bool = false;
    pub var usingDataFileStore: bool = false;

    pub var usingDataFile: bool = false;
    pub var usingBytecode: bool = false;
    pub var bytecodeMode: RetroBytecodeFormat = .BYTECODE_MOBILE;
    pub var forceFolder: bool = false;

    pub var dataFile: []const u8 = undefined;

    pub var initialised: bool = false;
    pub var running: bool = false;

    pub var gameMode: i32 = 1;
    pub var language: RetroLanguages = .RETRO_EN;
    pub var message: i32 = 0;
    pub var highResMode: bool = false;
    pub var useFBTexture: bool = false;

    pub var trialMode: bool = false;
    pub var onlineActive: bool = true;

    pub var frameSkipSetting: i32 = 0;
    pub var frameSkipTimer: i32 = 0;

    pub var useSteamDir: bool = true;

    pub var startListGame: i32 = -1;
    pub var startStageGame: i32 = -1;

    pub var devMenu: bool = false;
    pub var startList: i32 = -1;
    pub var startStage: i32 = -1;
    pub var gameSpeed: i32 = 1;
    pub var fastForwardSpeed: i32 = 8;
    pub var masterPaused: bool = false;
    pub var frameStep: bool = false;
    pub var dimTimer: i32 = 0;
    pub var dimLimit: i32 = 0;
    pub var dimPercent: f32 = 1.0;
    pub var dimMax: f32 = 1.0;

    pub var startSceneFolder: []const u8 = undefined;
    pub var startSceneID: []const u8 = undefined;

    pub var hasFocus: bool = true;
    pub var focusState: u8 = 0;

    pub var gameWindowText: []const u8 = undefined;
    pub var gameDescriptionText: []const u8 = undefined;
    pub var gameVersion: []const u8 = "1.3.0";

    pub var gameRenderType: RetroRenderTypes = .RENDER_SW;

    pub var gameTypeID: i32 = 0;
    pub var releaseType: []const u8 = "Use_Standalone";

    pub var frameBuffer: u16 = undefined;
    pub var frameBuffer2x: u16 = undefined;

    pub var texBuffer: u32 = undefined;
    pub var texBuffer2x: u32 = undefined;

    pub var isFullScreen: bool = false;

    pub var startFullScreen: bool = false;
    pub var borderless: bool = false;
    pub var vsync: bool = false;
    pub var scalingMode: i32 = 0;
    pub var windowScale: i32 = 2;
    pub var refreshRate: i32 = 60;
    pub var screenRefreshRate: i32 = 60;
    pub var targetRefreshRate: i32 = 60;

    pub var frameCount: u32 = 0;
    pub var renderFrameIndex: i32 = 0;
    pub var skipFrameIndex: i32 = 0;

    pub var windowXSize: i32 = undefined;
    pub var windowYSize: i32 = undefined;

    pub var window: *c.SDL_Window = undefined;
    pub var sdlEvents: *c.SDL_Event = undefined;
    pub var glContext: *c.SDL_GLContext = undefined;
};

pub const engine = RetroEngine;

pub fn init() !void {
    math.CalculateTrigAngles();
}
