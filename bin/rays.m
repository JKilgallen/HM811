pkg load image;

function rays = get_rays(H=1920, W=1080, UPSCALE_FACTOR=2, RAY_ANGLE=1, INNER_RADIUS=0, FLICKER=false)

    [X,Y] = meshgrid(-W*UPSCALE_FACTOR/2:1:W*UPSCALE_FACTOR/2, -H*UPSCALE_FACTOR/2:1:H*UPSCALE_FACTOR/2);
    mapping = repelem(repmat([1; 0], (360/RAY_ANGLE/2) + 1, 1), RAY_ANGLE);

    offset = FLICKER*RAY_ANGLE;
    mapping = circshift(mapping, offset);


    f = @(x,y) mapping(round(atan2(x,y)*180/pi) + 181);
    rays = f(X, Y);
    rays(sqrt(X.^2 + Y.^2) < INNER_RADIUS*UPSCALE_FACTOR) = FLICKER;
    rays = imresize(rays, [H W], "bicubic");
end

H = 1024; W = 1024;
FPS = 15;
UPSCALE_FACTOR = 4;
RAY_ANGLE = 4;
INNER_RADIUS = 0;
animation_out = sprintf('../reports/plots/ray_flicker_%i_%i_%i_%i_%i.gif', H, W, UPSCALE_FACTOR, RAY_ANGLE, INNER_RADIUS);


image_1 = get_rays(H, W, UPSCALE_FACTOR, RAY_ANGLE, INNER_RADIUS, true);
image_2 = get_rays(H, W, UPSCALE_FACTOR, RAY_ANGLE, INNER_RADIUS, false);

imwrite(image_1, animation_out, 'gif', 'DelayTime', 1/FPS);
imwrite(image_2, animation_out, 'gif', 'WriteMode', 'append', 'DelayTime', 1/FPS);

static_image_out = sprintf('../reports/plots/ray_static_%i_%i_%i_%i.png', H, W, UPSCALE_FACTOR, RAY_ANGLE);
static_image = get_rays(H, W, UPSCALE_FACTOR, RAY_ANGLE, 0, false);
imwrite(static_image, static_image_out);
