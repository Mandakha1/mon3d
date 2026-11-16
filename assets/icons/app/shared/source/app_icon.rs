//! The MonSolid mark, shared by desktop, packaging and CLI: an isometric cube in the colours of
//! the Mongolian flag (red, blue, red) with a Soyombo-gold top, three faces with transparent gaps
//! between them. MonSolid's own artwork; it replaces SolidCraft's mark in this fork.
type P = (f32, f32);

/// One face in that SVG's units: its outline, and its linear gradient from one point and
/// colour to another.
struct Face {
    outline: &'static [P],
    from: (P, [u8; 3]),
    to: (P, [u8; 3]),
}

const FACES: [Face; 3] = [
    // Left face: the flag's red.
    Face {
        outline: &[(160.100, 318.040), (503.900, 516.680), (503.900, 913.960), (160.100, 715.320)],
        from: ((152.0, 304.0), [218, 41, 58]),
        to: ((512.0, 928.0), [158, 18, 36]),
    },
    // Right face: the flag's blue.
    Face {
        outline: &[(520.100, 516.680), (863.900, 318.040), (863.900, 715.320), (520.100, 913.960)],
        from: ((512.0, 512.0), [18, 110, 196]),
        to: ((872.0, 720.0), [0, 62, 128]),
    },
    // Top: the Soyombo gold.
    Face {
        outline: &[(512.000, 105.360), (855.800, 304.000), (512.000, 502.640), (168.200, 304.000)],
        from: ((152.0, 304.0), [252, 212, 40]),
        to: ((872.0, 304.0), [226, 160, 0]),
    },
];

/// The mark's extent in SVG units: left, top, width, height.
const BOUNDS: (f32, f32, f32, f32) = (160.100, 105.360, 703.800, 808.600);

/// This block is the icon image data
pub fn rgba(size: usize) -> Result<Vec<u8>, String> {
    if !(1..=2048).contains(&size) {
        return Err("icon size must be 1..=2048".into());
    }
    // Coverage buffer at 4x4 samples per pixel (2x2 for big sizes), averaged down at the end.
    let ss = if size > 512 { 2 } else { 4 };
    let n = size * ss;
    let mut buf = vec![[0u8; 4]; n * n];
    let (bx, by, bw, bh) = BOUNDS;
    let s = n as f32 / bh; // SVG units -> samples: the mark fills the height
    let (ox, oy) = ((n as f32 - bw * s) / 2.0 - bx * s, -by * s); // and is centred sideways
    // Fill each face's outline (even-odd spans per row, so concave outlines work) with its gradient.
    for face in &FACES {
        let v: Vec<P> = face.outline.iter().map(|p| (ox + p.0 * s, oy + p.1 * s)).collect();
        let (((fx, fy), c0), ((tx, ty), c1)) = (face.from, face.to);
        let (gx, gy) = (tx - fx, ty - fy);
        let g2 = gx * gx + gy * gy;
        let (top, bottom) = v.iter().fold((f32::MAX, f32::MIN), |(a, b), p| (a.min(p.1), b.max(p.1)));
        let mut xs = Vec::with_capacity(v.len());
        for y in ((top - 0.5).ceil() as i32).max(0)..=((bottom - 0.5).floor() as i32).min(n as i32 - 1) {
            let cy = y as f32 + 0.5;
            xs.clear();
            for i in 0..v.len() {
                let (a, b) = (v[i], v[(i + 1) % v.len()]);
                if (a.1 <= cy) != (b.1 <= cy) {
                    xs.push(a.0 + (cy - a.1) / (b.1 - a.1) * (b.0 - a.0));
                }
            }
            xs.sort_by(f32::total_cmp);
            for &[from, to] in xs.as_chunks::<2>().0 {
                for x in ((from - 0.5).ceil() as i32).max(0)..=((to - 0.5).floor() as i32).min(n as i32 - 1) {
                    // The sample's place along the gradient, in SVG units.
                    let (px, py) = ((x as f32 + 0.5 - ox) / s, (cy - oy) / s);
                    let t = (((px - fx) * gx + (py - fy) * gy) / g2).clamp(0.0, 1.0);
                    let mix = |k: usize| (f32::from(c0[k]) + (f32::from(c1[k]) - f32::from(c0[k])) * t).round() as u8;
                    buf[y as usize * n + x as usize] = [mix(0), mix(1), mix(2), 255];
                }
            }
        }
    }
    // Average each ss x ss block down to one pixel (straight alpha = covered share).
    let mut rgba = Vec::with_capacity(size * size * 4);
    for y in 0..size {
        for x in 0..size {
            let (mut sum, mut cnt) = ([0u32; 3], 0u32);
            for j in 0..ss {
                for i in 0..ss {
                    let p = buf[(y * ss + j) * n + x * ss + i];
                    if p[3] != 0 {
                        cnt += 1;
                        for k in 0..3 {
                            sum[k] += u32::from(p[k]);
                        }
                    }
                }
            }
            if cnt == 0 {
                rgba.extend_from_slice(&[0, 0, 0, 0]);
            } else {
                let a = 255 * cnt / (ss * ss) as u32;
                rgba.extend_from_slice(&[(sum[0] / cnt) as u8, (sum[1] / cnt) as u8, (sum[2] / cnt) as u8, a as u8]);
            }
        }
    }
    Ok(rgba)
}

#[cfg(test)]
mod tests {
    #[test]
    fn shared_mark_has_transparency_and_its_colours_at_window_and_package_sizes() {
        for size in [16, 24, 32, 48, 64, 128, 256] {
            let pixels = super::rgba(size).expect("valid size");
            assert_eq!(pixels.len(), size * size * 4);
            assert!(pixels.as_chunks::<4>().0.iter().any(|p| p[3] == 0));
            assert!(pixels.as_chunks::<4>().0.iter().any(|p| p[3] == 255 && p[2] > p[0]), "the blue face");
            assert!(pixels.as_chunks::<4>().0.iter().any(|p| p[3] == 255 && p[0] > p[2] + 100 && p[1] < 80), "the red face");
        }
        assert!(super::rgba(0).is_err());
        assert!(super::rgba(2049).is_err());
    }

    /// Borderless: the seam between the left and right faces (the cube's front edge, x 512) is
    /// see-through on the row through the middle of the mark, with a face on each side.
    #[test]
    fn shared_mark_is_borderless() {
        let size = 256;
        let pixels = super::rgba(size).expect("valid size");
        let px = |x: usize, y: usize| pixels.as_chunks::<4>().0[y * size + x];
        let (bx, by, bw, bh) = super::BOUNDS;
        let s = size as f32 / bh;
        let gap_x = ((size as f32 - bw * s) / 2.0 + (512.0 - bx) * s) as usize;
        let row = ((720.0 - by) * s) as usize;
        assert_eq!(px(gap_x, row)[3], 0, "the seam between the left and right faces is a gap");
        assert!(px(gap_x - 8, row)[3] == 255 && px(gap_x + 8, row)[3] == 255, "faces on both sides of the gap");
    }
}
