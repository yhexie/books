function [tz,uz] = neuler(f,t0,u0,tf,h,c)
%
%  [tz,uz] = neuler(f,t0,u0,tf,h,c)
%    
%  Uses Euler method to solve a first order ODE and
%    plots components of the solution.
%    In 2-D case, also plots phase plane in Figure #2
%
% Input arguments:
%
%   f  - string name of function on right hand side of ODE: u' = f(t,u)
%            note: f must return a column vector
%   t0 - initial time
%   u0 - initial data u(t0) --- column vector
%   tf - final time or, if vector, list of times to evaluate solution.
%   h  - step size
%
% Optional arguments:
%
%   c  - color for plot
%
% Output:
%
%   tz - times for evaluation of function as specified by tf, or, 
%        if tf is a scalar, all mesh points
%   uz - value of solution at times tz.
%
% See also NUMODE, MIDP, IEULER, RK4, NEULERF, IEULERF, MIDPF, RK4F
%

[tz,uz] = numode('neulerf',f,t0,u0,tf,h,c);
