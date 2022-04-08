#include <utils/ray.glsl>

struct DDA_StartResult {
    vec3 delta_dist;
    ivec3 ray_step;
    vec3 initial_to_side_dist;
    vec3 initial_to_side_dist_x2;
    vec3 initial_to_side_dist_x4;
    vec3 initial_to_side_dist_x8;
    vec3 initial_to_side_dist_x16;
    vec3 initial_to_side_dist_x32;
    vec3 initial_to_side_dist_x64;
};

struct DDA_RunState {
    vec3 to_side_dist;
    vec3 to_side_dist_x2;
    vec3 to_side_dist_x4;
    vec3 to_side_dist_x8;
    vec3 to_side_dist_x16;
    vec3 to_side_dist_x32;
    vec3 to_side_dist_x64;
    ivec3 tile_i;
    ivec3 tile_i_x2;
    ivec3 tile_i_x4;
    ivec3 tile_i_x8;
    ivec3 tile_i_x16;
    ivec3 tile_i_x32;
    ivec3 tile_i_x64;
    uint side;
    uint total_steps;
    bool hit, outside_bounds;
};

DDA_StartResult run_dda_start(in Ray ray, in out DDA_RunState run_state) {
    DDA_StartResult result;
    result.delta_dist = vec3(
        ray.nrm.x == 0 ? 1 : abs(ray.inv_nrm.x),
        ray.nrm.y == 0 ? 1 : abs(ray.inv_nrm.y),
        ray.nrm.z == 0 ? 1 : abs(ray.inv_nrm.z));
    run_state.tile_i = ivec3(ray.o / 1) * 1;
    run_state.tile_i_x2 = ivec3(ray.o / 2) * 2;
    run_state.tile_i_x4 = ivec3(ray.o / 4) * 4;
    run_state.tile_i_x8 = ivec3(ray.o / 8) * 8;
    run_state.tile_i_x16 = ivec3(ray.o / 16) * 16;
    run_state.tile_i_x32 = ivec3(ray.o / 32) * 32;
    run_state.tile_i_x64 = ivec3(ray.o / 64) * 64;
    if (ray.nrm.x < 0) {
        result.ray_step.x = -1;
        run_state.to_side_dist.x = (ray.o.x - run_state.tile_i.x) * result.delta_dist.x;
        run_state.to_side_dist_x2.x = (ray.o.x - run_state.tile_i_x2.x) * result.delta_dist.x;
        run_state.to_side_dist_x4.x = (ray.o.x - run_state.tile_i_x4.x) * result.delta_dist.x;
        run_state.to_side_dist_x8.x = (ray.o.x - run_state.tile_i_x8.x) * result.delta_dist.x;
        run_state.to_side_dist_x16.x = (ray.o.x - run_state.tile_i_x16.x) * result.delta_dist.x;
        run_state.to_side_dist_x32.x = (ray.o.x - run_state.tile_i_x32.x) * result.delta_dist.x;
        run_state.to_side_dist_x64.x = (ray.o.x - run_state.tile_i_x64.x) * result.delta_dist.x;
    } else {
        result.ray_step.x = 1;
        run_state.to_side_dist.x = (run_state.tile_i.x + 1 - ray.o.x) * result.delta_dist.x;
        run_state.to_side_dist_x2.x = (run_state.tile_i_x2.x + 2 - ray.o.x) * result.delta_dist.x;
        run_state.to_side_dist_x4.x = (run_state.tile_i_x4.x + 4 - ray.o.x) * result.delta_dist.x;
        run_state.to_side_dist_x8.x = (run_state.tile_i_x8.x + 8 - ray.o.x) * result.delta_dist.x;
        run_state.to_side_dist_x16.x = (run_state.tile_i_x16.x + 16 - ray.o.x) * result.delta_dist.x;
        run_state.to_side_dist_x32.x = (run_state.tile_i_x32.x + 32 - ray.o.x) * result.delta_dist.x;
        run_state.to_side_dist_x64.x = (run_state.tile_i_x64.x + 64 - ray.o.x) * result.delta_dist.x;
    }
    if (ray.nrm.y < 0) {
        result.ray_step.y = -1;
        run_state.to_side_dist.y = (ray.o.y - run_state.tile_i.y) * result.delta_dist.y;
        run_state.to_side_dist_x2.y = (ray.o.y - run_state.tile_i_x2.y) * result.delta_dist.y;
        run_state.to_side_dist_x4.y = (ray.o.y - run_state.tile_i_x4.y) * result.delta_dist.y;
        run_state.to_side_dist_x8.y = (ray.o.y - run_state.tile_i_x8.y) * result.delta_dist.y;
        run_state.to_side_dist_x16.y = (ray.o.y - run_state.tile_i_x16.y) * result.delta_dist.y;
        run_state.to_side_dist_x32.y = (ray.o.y - run_state.tile_i_x32.y) * result.delta_dist.y;
        run_state.to_side_dist_x64.y = (ray.o.y - run_state.tile_i_x64.y) * result.delta_dist.y;
    } else {
        result.ray_step.y = 1;
        run_state.to_side_dist.y = (run_state.tile_i.y + 1 - ray.o.y) * result.delta_dist.y;
        run_state.to_side_dist_x2.y = (run_state.tile_i_x2.y + 2 - ray.o.y) * result.delta_dist.y;
        run_state.to_side_dist_x4.y = (run_state.tile_i_x4.y + 4 - ray.o.y) * result.delta_dist.y;
        run_state.to_side_dist_x8.y = (run_state.tile_i_x8.y + 8 - ray.o.y) * result.delta_dist.y;
        run_state.to_side_dist_x16.y = (run_state.tile_i_x16.y + 16 - ray.o.y) * result.delta_dist.y;
        run_state.to_side_dist_x32.y = (run_state.tile_i_x32.y + 32 - ray.o.y) * result.delta_dist.y;
        run_state.to_side_dist_x64.y = (run_state.tile_i_x64.y + 64 - ray.o.y) * result.delta_dist.y;
    }
    if (ray.nrm.z < 0) {
        result.ray_step.z = -1;
        run_state.to_side_dist.z = (ray.o.z - run_state.tile_i.z) * result.delta_dist.z;
        run_state.to_side_dist_x2.z = (ray.o.z - run_state.tile_i_x2.z) * result.delta_dist.z;
        run_state.to_side_dist_x4.z = (ray.o.z - run_state.tile_i_x4.z) * result.delta_dist.z;
        run_state.to_side_dist_x8.z = (ray.o.z - run_state.tile_i_x8.z) * result.delta_dist.z;
        run_state.to_side_dist_x16.z = (ray.o.z - run_state.tile_i_x16.z) * result.delta_dist.z;
        run_state.to_side_dist_x32.z = (ray.o.z - run_state.tile_i_x32.z) * result.delta_dist.z;
        run_state.to_side_dist_x64.z = (ray.o.z - run_state.tile_i_x64.z) * result.delta_dist.z;
    } else {
        result.ray_step.z = 1;
        run_state.to_side_dist.z = (run_state.tile_i.z + 1 - ray.o.z) * result.delta_dist.z;
        run_state.to_side_dist_x2.z = (run_state.tile_i_x2.z + 2 - ray.o.z) * result.delta_dist.z;
        run_state.to_side_dist_x4.z = (run_state.tile_i_x4.z + 4 - ray.o.z) * result.delta_dist.z;
        run_state.to_side_dist_x8.z = (run_state.tile_i_x8.z + 8 - ray.o.z) * result.delta_dist.z;
        run_state.to_side_dist_x16.z = (run_state.tile_i_x16.z + 16 - ray.o.z) * result.delta_dist.z;
        run_state.to_side_dist_x32.z = (run_state.tile_i_x32.z + 32 - ray.o.z) * result.delta_dist.z;
        run_state.to_side_dist_x64.z = (run_state.tile_i_x64.z + 64 - ray.o.z) * result.delta_dist.z;
    }
    result.initial_to_side_dist = run_state.to_side_dist;
    result.initial_to_side_dist_x2 = run_state.to_side_dist_x2;
    result.initial_to_side_dist_x4 = run_state.to_side_dist_x4;
    result.initial_to_side_dist_x8 = run_state.to_side_dist_x8;
    result.initial_to_side_dist_x16 = run_state.to_side_dist_x16;
    result.initial_to_side_dist_x32 = run_state.to_side_dist_x32;
    result.initial_to_side_dist_x64 = run_state.to_side_dist_x64;
    return result;
}

void run_dda_step(in out vec3 to_side_dist, in out ivec3 tile_i, in out uint side, in DDA_StartResult dda_start, in int scl) {
    if (to_side_dist.x < to_side_dist.y) {
        if (to_side_dist.x < to_side_dist.z) {
            to_side_dist.x += dda_start.delta_dist.x * scl;
            tile_i.x += dda_start.ray_step.x * scl;
            side = 0; // x
        } else {
            to_side_dist.z += dda_start.delta_dist.z * scl;
            tile_i.z += dda_start.ray_step.z * scl;
            side = 2; // z
        }
    } else {
        if (to_side_dist.y < to_side_dist.z) {
            to_side_dist.y += dda_start.delta_dist.y * scl;
            tile_i.y += dda_start.ray_step.y * scl;
            side = 1; // y
        } else {
            to_side_dist.z += dda_start.delta_dist.z * scl;
            tile_i.z += dda_start.ray_step.z * scl;
            side = 2; // z
        }
    }
}

void run_dda_main(in Ray ray, in DDA_StartResult dda_start, in out DDA_RunState run_state, in vec3 b_min, in vec3 b_max, in uint max_steps) {
    run_state.hit = false;
    uint x1_steps = 0;

#if VISUALIZE_SUBGRID == 0
    // TODO: figure out why this is necessary
    // 10% perf hit with shadows (worst case)
    // if (load_block_presence_16x(run_state.tile_i_x16)) {
    //     for (uint j = 0; j < 12; ++j) {
    //         uint tile = load_tile(run_state.tile_i);
    //         if (is_block_occluding(get_block_id(tile))) {
    //             run_state.hit = true;
    //             break;
    //         }
    //         run_dda_step(run_state.to_side_dist, run_state.tile_i, run_state.side, dda_start, 1);
    //         if (run_state.tile_i / 4 == run_state.tile_i_x4)
    //             break;
    //         x1_steps++;
    //         if (!point_box_contains(run_state.tile_i, b_min, b_max)) {
    //             run_state.outside_bounds = true;
    //             break;
    //         }
    //     }

    //     if (load_block_presence_16x(run_state.tile_i / 16 * 16)) {
    //         for (uint j = 0; j < 36; ++j) {
    //             uint tile = load_tile(run_state.tile_i);
    //             if (is_block_occluding(get_block_id(tile))) {
    //                 run_state.hit = true;
    //                 break;
    //             }
    //             run_dda_step(run_state.to_side_dist, run_state.tile_i, run_state.side, dda_start, 1);
    //             if (run_state.tile_i / 4 == run_state.tile_i_x4)
    //                 break;
    //             x1_steps++;
    //             if (!point_box_contains(run_state.tile_i, b_min, b_max)) {
    //                 run_state.outside_bounds = true;
    //                 break;
    //             }
    //         }
    //     }
    // }
    // Do this ^ for 16 separately, only if necessary, instead
    // of always stepping all the way to an x16 boundary
#endif

    for (run_state.total_steps = 0; run_state.total_steps < max_steps; ++run_state.total_steps) {
        if (run_state.hit)
            break;
#if VISUALIZE_SUBGRID == 0
#if ENABLE_X16
        x1_steps++;
        // ivec3 prev_tile_i_x16 = run_state.tile_i_x16;
        run_dda_step(run_state.to_side_dist_x16, run_state.tile_i_x16, run_state.side, dda_start, 16);
        if (load_block_presence_16x(run_state.tile_i_x16)) {
            RayIntersection x16_intersection;
            x16_intersection.nrm = vec3(dda_start.ray_step * 1);
            switch (run_state.side) {
            case 0: x16_intersection.dist = run_state.to_side_dist_x16.x - dda_start.delta_dist.x * 16; break;
            case 1: x16_intersection.dist = run_state.to_side_dist_x16.y - dda_start.delta_dist.y * 16; break;
            case 2: x16_intersection.dist = run_state.to_side_dist_x16.z - dda_start.delta_dist.z * 16; break;
            }
            run_state.tile_i_x4 = ivec3(get_intersection_pos_corrected(ray, x16_intersection));
            run_state.tile_i_x4 = (run_state.tile_i_x4 / 4) * 4;
            run_state.to_side_dist_x4 = abs(vec3(ivec3(ray.o / 4) - run_state.tile_i_x4 / 4)) * dda_start.delta_dist * 4 + dda_start.initial_to_side_dist_x4;
            for (uint i = 0; i < 12; ++i) {
#endif
                x1_steps++;
                run_dda_step(run_state.to_side_dist_x4, run_state.tile_i_x4, run_state.side, dda_start, 4);
                if (load_block_presence_4x(run_state.tile_i_x4)) {
                    RayIntersection x4_intersection;
                    x4_intersection.nrm = vec3(dda_start.ray_step * 1);
                    switch (run_state.side) {
                    case 0: x4_intersection.dist = run_state.to_side_dist_x4.x - dda_start.delta_dist.x * 4; break;
                    case 1: x4_intersection.dist = run_state.to_side_dist_x4.y - dda_start.delta_dist.y * 4; break;
                    case 2: x4_intersection.dist = run_state.to_side_dist_x4.z - dda_start.delta_dist.z * 4; break;
                    }
                    run_state.tile_i = ivec3(get_intersection_pos_corrected(ray, x4_intersection));
                    run_state.to_side_dist = abs(vec3(ivec3(ray.o) - run_state.tile_i)) * dda_start.delta_dist + dda_start.initial_to_side_dist;
                    for (uint j = 0; j < 12; ++j) {
                        uint tile = load_tile(run_state.tile_i);
                        if (is_block_occluding(get_block_id(tile))) {
                            run_state.hit = true;
                            break;
                        }
                        x1_steps++;
                        run_dda_step(run_state.to_side_dist, run_state.tile_i, run_state.side, dda_start, 1);
                        if (run_state.tile_i / 4 == run_state.tile_i_x4)
                            break;
                        if (!point_box_contains(run_state.tile_i, b_min, b_max)) {
                            run_state.outside_bounds = true;
                            break;
                        }
                    }
                }
                if (run_state.hit || run_state.tile_i_x4 / 4 == run_state.tile_i_x16)
                    break;
                if (!point_box_contains(run_state.tile_i_x4, b_min, b_max)) {
                    run_state.outside_bounds = true;
                    break;
                }
#if ENABLE_X16
            }
        }
        if (!point_box_contains(run_state.tile_i_x16, b_min, b_max)) {
            run_state.outside_bounds = true;
            break;
        }
#endif
#else
        uint tile = load_tile(run_state.tile_i);
#if VISUALIZE_SUBGRID == 1
        if (is_block_occluding(get_block_id(tile))) {
#elif VISUALIZE_SUBGRID == 2
        if (load_block_presence_2x(run_state.tile_i_x2)) {
            run_state.to_side_dist = run_state.to_side_dist_x2;
#elif VISUALIZE_SUBGRID == 4
        if (load_block_presence_4x(run_state.tile_i_x4)) {
            run_state.to_side_dist = run_state.to_side_dist_x4;
#elif VISUALIZE_SUBGRID == 8
        if (load_block_presence_8x(run_state.tile_i_x8)) {
            run_state.to_side_dist = run_state.to_side_dist_x8;
#elif VISUALIZE_SUBGRID == 16
        if (load_block_presence_16x(run_state.tile_i_x16)) {
            run_state.to_side_dist = run_state.to_side_dist_x16;
#elif VISUALIZE_SUBGRID == 32
        if (load_block_presence_32x(run_state.tile_i_x32)) {
            run_state.to_side_dist = run_state.to_side_dist_x32;
#elif VISUALIZE_SUBGRID == 64
        if (load_block_presence_64x(run_state.tile_i_x64)) {
            run_state.to_side_dist = run_state.to_side_dist_x64;
#endif
            run_state.hit = true;
            break;
        }

#if VISUALIZE_SUBGRID == 1
        run_dda_step(run_state.to_side_dist, run_state.tile_i, run_state.side, dda_start, 1);
#elif VISUALIZE_SUBGRID == 2
        run_dda_step(run_state.to_side_dist_x2, run_state.tile_i_x2, run_state.side, dda_start, 2);
#elif VISUALIZE_SUBGRID == 4
        run_dda_step(run_state.to_side_dist_x4, run_state.tile_i_x4, run_state.side, dda_start, 4);
#elif VISUALIZE_SUBGRID == 8
        run_dda_step(run_state.to_side_dist_x8, run_state.tile_i_x8, run_state.side, dda_start, 8);
#elif VISUALIZE_SUBGRID == 16
        run_dda_step(run_state.to_side_dist_x16, run_state.tile_i_x16, run_state.side, dda_start, 16);
#elif VISUALIZE_SUBGRID == 32
        run_dda_step(run_state.to_side_dist_x32, run_state.tile_i_x32, run_state.side, dda_start, 32);
#elif VISUALIZE_SUBGRID == 64
        run_dda_step(run_state.to_side_dist_x64, run_state.tile_i_x64, run_state.side, dda_start, 64);
#endif

#if VISUALIZE_SUBGRID == 1
        if (!point_box_contains(run_state.tile_i, b_min, b_max)) {
#elif VISUALIZE_SUBGRID == 2
        if (!point_box_contains(run_state.tile_i_x2, b_min, b_max)) {
#elif VISUALIZE_SUBGRID == 4
        if (!point_box_contains(run_state.tile_i_x4, b_min, b_max)) {
#elif VISUALIZE_SUBGRID == 8
        if (!point_box_contains(run_state.tile_i_x8, b_min, b_max)) {
#elif VISUALIZE_SUBGRID == 16
        if (!point_box_contains(run_state.tile_i_x16, b_min, b_max)) {
#elif VISUALIZE_SUBGRID == 32
        if (!point_box_contains(run_state.tile_i_x32, b_min, b_max)) {
#elif VISUALIZE_SUBGRID == 64
        if (!point_box_contains(run_state.tile_i_x64, b_min, b_max)) {
#endif
            run_state.outside_bounds = true;
            break;
        }
#endif
    }
#if VISUALIZE_SUBGRID == 0
    run_state.total_steps = x1_steps;
#endif
}