//! Mon3D's name, in one place. The product is named after its year, like other CAD releases:
//! next year change [`YEAR`] (and [`FULL_NAME`]) and nothing else. Per-user folders, the
//! executables and the update channel stay without the year, so a new year's release keeps the
//! settings and autosaves of the one before.

/// The product name without the year: folders, messages, the MCP server.
pub const NAME: &str = "Mon3D";
/// The release year shown with the name.
pub const YEAR: &str = "2026";
/// What the window title, the About window and the installer show.
pub const FULL_NAME: &str = "Mon3D 2026";
/// The id Windows shows Mon3D's notifications under; the installer registers it.
pub const AUMID: &str = "MonHydro.Mon3D";
/// The project Mon3D is based on, credited in About (Apache-2.0 / MIT, NOTICE kept).
pub const UPSTREAM: &str = "https://github.com/tangency-labs/solidcraft";
/// Mon3D's own source repository.
pub const SOURCE: &str = "https://github.com/Mandakha1/mon3d";

#[cfg(test)]
mod tests {
    #[test]
    fn the_full_name_is_the_name_and_the_year() {
        assert_eq!(super::FULL_NAME, format!("{} {}", super::NAME, super::YEAR));
        assert!(super::YEAR.len() == 4 && super::YEAR.chars().all(|c| c.is_ascii_digit()));
    }
}

/// Mon3D's mark in the application bar: the app icon's cube (red, blue, gold) as three faces with
/// gaps, `height` points tall, centred on `c`. Drawn here, not with SolidCraft's mark.
pub fn paint_mark(p: &egui::Painter, c: egui::Pos2, height: f32) {
    use egui::{Color32, Shape, Stroke, pos2};
    // The icon's geometry (app_icon.rs), in its 1024-unit square, centred on the cube.
    let s = height / 808.6;
    let at = |x: f32, y: f32| pos2(c.x + (x - 512.0) * s, c.y + (y - 509.66) * s);
    let face = |pts: [(f32, f32); 4], col: Color32| {
        p.add(Shape::convex_polygon(pts.iter().map(|&(x, y)| at(x, y)).collect(), col, Stroke::NONE));
    };
    face([(160.1, 318.04), (503.9, 516.68), (503.9, 913.96), (160.1, 715.32)], Color32::from_rgb(198, 33, 50));
    face([(520.1, 516.68), (863.9, 318.04), (863.9, 715.32), (520.1, 913.96)], Color32::from_rgb(10, 88, 168));
    face([(512.0, 105.36), (855.8, 304.0), (512.0, 502.64), (168.2, 304.0)], Color32::from_rgb(244, 192, 24));
}
