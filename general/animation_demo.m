tt = 0:0.01:10*pi; x = t.*sin(t); y = t.*cos(t);
= 0:0.01:10*pi; x = t.*sin(t); y = t.*cos(t);
axislimits = [min(x) max(x) min(y) max(y) min(t) max(t)];
axislimits = [min(x) max(x) min(y) max(y) min(t) max(t)];
line_handle = plot3(x(1), y(1),t(1), 'ko', ...
line_handle = plot3(x(1), y(1),t(1),
'MarkerFaceColor',[.49 1 .63], 'MarkerSize',12);
'MarkerFaceColor',[.49 1 .63], 'MarkerSize',12);
set(line_handle, 'erasemode','xor');
set(line_handle, 'erasemode','xor');
axis(axislimits);
axis(axislimits);
grid on
grid on
for ii = 2:length(x)
for = 2:length(x)
set(line_handle, 'xdata',x(i), 'ydata', y(i), 'zdata', t(i));
set(line_handle,
drawnow;
drawnow;
end
