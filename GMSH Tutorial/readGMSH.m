function [ mesh ] = readGMSH( filename )
%Output mesh structure for GMSH-generated meshes
file = fopen(filename);
mesh = {};

%% Skip past the header
tline = fgetl(file);
while ischar(tline) && strcmp(tline,'$Nodes') == 0
    tline = fgetl(file);
end

%% Populate node array
mesh.nodeNumber = str2num(fgetl(file));
mesh.nodes = zeros(mesh.nodeNumber, 3);
tline = fgetl(file);
while ischar(tline) && strcmp(tline,'$EndNodes') == 0
    line = str2double(strsplit(tline, ' '));
    mesh.nodes(line(1),:) = [line(2), line(3), line(4)];
    tline = fgetl(file);
end

%% Populate element array
tline = fgetl(file);
mesh.elementNumber = str2num(fgetl(file));
mesh.elements = zeros(mesh.elementNumber, 3); %Change 2nd argument based on element type and order
mesh.primitives = zeros(mesh.elementNumber, 3);
mesh.edges = zeros(mesh.elementNumber, 2);
mesh.ID = zeros(mesh.elementNumber, 1);
tline = fgetl(file);
while ischar(tline) && strcmp(tline,'$EndElements') == 0
    line = str2double(strsplit(tline, ' '));
    switch length(strsplit(tline, ' '))
        case 6
            mesh.edges(line(1),:) = [line(6), 0];
            mesh.ID(line(6)) = line(5);
        case 7
            mesh.edges(line(1),:) = [line(6), line(7)];
            mesh.ID(line(6)) = line(5);
            mesh.ID(line(7)) = line(5);
        case 8
            mesh.elements(line(1),:) = [line(end-2), line(end-1), line(end)];
%             mesh.ID(line(1)) = line(5);
    end
    tline = fgetl(file);
end

fclose(file);
end

