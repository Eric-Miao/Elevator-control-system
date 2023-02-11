classdef FLoor < handle
    
    properties
        % 0:not inqueue 1:inqueue
        validation
        floor
        % three kinds of directions: up down null and both
        direction
    end
    
    methods
        function obj = Floor(f,d)
            obj.floor = f;
            obj.direction = d;
        end
    end
    
end