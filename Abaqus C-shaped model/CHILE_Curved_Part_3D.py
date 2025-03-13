## =================================================================================== ##
## This script implements 3D curved section with user-subroutines and input file       ##
## =================================================================================== ##

# set your work directory
# put 'r' (rawstring) at the path beginning to avoid unicode error
# put python script and input file in this folder

# this is your work directory
wd = r'E:\\ABAQUS\\CHILEModel_XP'
# this is the directory of subroutine file
subroutine_path = 'E:\\ABAQUS\\CHILEModel_XP\\chile_addme.for'
# name your model and jobs
modelname = 'Model-exmaple'
jobname = 'Job-example'
materialname = 'CHILE'
## ============================================== ##
##                 default setting                ##
## ============================================== ##
import os
from abaqus import *
from abaqusConstants import *
import __main__
# change work directory
cwd = os.getcwd()
print ("current work dir = %s" % cwd)
os.chdir("%s" % wd)
print ("change work dir = %s" % wd)
backwardCompatibility.setValues(includeDeprecated=True,
                                reportDeprecated=False)
# change background
session.graphicsOptions.setValues(backgroundStyle=SOLID, 
    backgroundColor='#FFFFFF')
# change geom feature records (index2coor)
session.journalOptions.setValues(replayGeometry=COORDINATE, 
                                recoverGeometry=COORDINATE)
import section
import regionToolset
import displayGroupMdbToolset as dgm
import part
import material
import assembly
import step
import interaction
import load
import mesh
import optimization
import job
import sketch
import visualization
import xyPlot
import displayGroupOdbToolset as dgo
import connectorBehavior
from math import *
from CHILE_Define_Inputs_Here import *
## ============================================== ##
##                    Geometry                    ##
## ============================================== ##
n_ply = 4                          # number of plies
list_orient = [0,90,90,0]            
# n_ply = 8                          # number of plies
# list_orient = [0,90,0,90,90,0,90,0]            
# n_ply = 12                          # number of plies
# list_orient = [0,90,0,90,0,90,90,0,90,0,90,0] 
# n_ply = 16                          # number of plies
# list_orient = [0,90,0,90,0,90,0,90,90,0,90,0,90,0,90,0] 

TubeRadius = 6e-3                  # outer radius of the part         
depth = TubeRadius/2                # width of the part

mdb.Model(name=modelname, modelType=STANDARD_EXPLICIT)

angle = radians(angle_degree)
radius = TubeRadius-thickness*n_ply
point41=(0.0, radius)
point42=(0.0, radius+thickness*n_ply)
#180<angle<270
point43=(sin(angle)*radius,cos(angle)*radius)
point44=(sin(angle)*(radius+thickness*n_ply), cos(angle)*(radius+thickness*n_ply))
#90<angle<180
# point43=(-cos(angle)*radius, -sin(angle)*radius)
# point44=(-cos(angle)*(radius+thickness*n_ply), -sin(angle)*(radius+thickness*n_ply))
# sketch the geometry ----------------------------------------------------
s1 = mdb.models[modelname].ConstrainedSketch(name='__profile__', 
    sheetSize=200.0)
g, v, d, c = s1.geometry, s1.vertices, s1.dimensions, s1.constraints
s1.setPrimaryObject(option=STANDALONE)
s1.ArcByCenterEnds(center=(0.0, 0.0), point1=point41, point2=point43, direction=CLOCKWISE)
s1.ArcByCenterEnds(center=(0.0, 0.0), point1=point42, point2=point44, direction=CLOCKWISE)
s1.Line(point1=point41, point2=point42)
s1.Line(point1=point43, point2=point44)
p = mdb.models[modelname].Part(name='Part-1', dimensionality=THREE_D,
    type=DEFORMABLE_BODY)
p = mdb.models[modelname].parts['Part-1']
p.BaseSolidExtrude(sketch=s1, depth=depth)
s1.unsetPrimaryObject()
del mdb.models[modelname].sketches['__profile__']
# create partitions ------------------------------------------------------
# create partition (define cutting on side face)
f, c = p.faces, p.cells
v, e, d = p.vertices, p.edges, p.datums     
for i1 in range(n_ply-1):
    p.DatumPointByCoordinate(coords=(0.0, radius+thickness*(i1+1), 0.0))
    p.DatumPointByCoordinate(coords=(0.0, radius+thickness*(i1+1), depth))
    name_datumpt = 'Datum pt-'+str(i1*2+1)
    datumID1=p.features[name_datumpt].id
    datumID2=datumID1+1
    pickedFaces = f.findAt(((0.0, radius+thickness*(n_ply-1), depth/2.0), ))
    p.PartitionFaceByShortestPath(point1=d[datumID1], point2=d[datumID2], faces=pickedFaces)
# create partition (sweeping along an curved edge)
for i1 in range(n_ply-1):
    pickedCells = c.findAt(((0.0, radius+thickness*n_ply, depth/2.0), ))
    pickedEdges =(e.findAt(coordinates=(0.0, radius+thickness*(i1+1), depth/2.0)), )
    p.PartitionCellBySweepEdge(sweepPath=e.findAt(coordinates=(radius, 0.0, 0.0)), 
        cells=pickedCells, edges=pickedEdges)
## ============================================== ##
##                       Sets                     ##
## ============================================== ##
p = mdb.models[modelname].parts['Part-1']
f, e, d = p.faces, p.edges, p.datums
session.viewports['Viewport: 1'].setValues(displayedObject=p)

edges = e.findAt(((radius/sqrt(2.0), radius/sqrt(2.0), 0.0), ))
p.Set(edges=edges, name='ArcEdge')

edges = e.findAt(((0.0, radius, depth/2.0), ))
p.Set(edges=edges, name='BotZEdge')

edges = e.findAt(((0.0, radius+thickness*n_ply, depth/2.0), ))
p.Set(edges=edges, name='TopZEdge')

InnerSurf = f.findAt(((radius/sqrt(2.0), radius/sqrt(2.0), depth/2.0), ))
p.Surface(side1Faces=InnerSurf, name='InnerSurf')
p.Set(faces=InnerSurf, name='InnerSurf')

OuterSurf = f.findAt((((radius+thickness*n_ply)/sqrt(2.0), 
    (radius+thickness*n_ply)/sqrt(2.0), depth/2.0), ))
p.Surface(side1Faces=OuterSurf, name='OuterSurf')
p.Set(faces=OuterSurf, name='OuterSurf')

faces = InnerSurf+OuterSurf
p.Set(faces=faces, name='TopBotSurf')

# create ply edge sets ----------------------------
ply_edges = [0]*n_ply
for i1 in range(n_ply):
    point_on_edge = (0.0, radius+thickness*(i1+0.5), depth/2.0)
    ply_edges[i1] = f.findAt((point_on_edge, ))
    set_name_edges = 'PlyEdge-%s'%(i1+1)
    p.Set(faces=ply_edges[i1], name=set_name_edges)

# create ply arch edge sets ----------------------------
ply_arch_edges = [0]*n_ply
for i1 in range(n_ply):
    mid_radius = radius+thickness*(i1+0.5)
    point_on_edge=(sin(angle/2)*mid_radius,cos(angle/2)*mid_radius,0.0)
    ply_arch_edges[i1] = f.findAt((point_on_edge, ))
    set_name_edges = 'PlyArchEdge-%s'%(i1+1)
    p.Set(faces=ply_arch_edges[i1], name=set_name_edges)

# create ply layer sets ---------------------------
for i1 in range(n_ply):
    cells = c.findAt(((0.0, radius+thickness*(i1+0.5), 0.0), ))
    layername = 'Layer-'+str(i1+1)
    p.Set(cells=cells, name=layername)

# create all cells set ----------------------------
c=p.cells
allcells=c[0:len(c)]
p.Set(cells=allcells, name='AllCells')
## ============================================== ##
##                       Mesh                     ##
## ============================================== ##
# control mesh size and generate mesh
for i1 in range(n_ply):
    point_on_edge1 = (0.0, radius+thickness*(i1+0.5), 0.0)
    pickedEdges = e.findAt((point_on_edge1, ))
    p.seedEdgeByNumber(edges=pickedEdges, number=seedEdgeNumber, constraint=FINER)
p.seedPart(size=seedPartSize, deviationFactor=0.1, minSizeFactor=0.1)
p.generateMesh()

# element type
# elemType1 = mesh.ElemType(elemCode=C3D8RT, elemLibrary=STANDARD, 
#     kinematicSplit=AVERAGE_STRAIN, secondOrderAccuracy=OFF, 
#     hourglassControl=ENHANCED, distortionControl=DEFAULT)
elemType1 = mesh.ElemType(elemCode=C3D8T, elemLibrary=STANDARD, 
    secondOrderAccuracy=OFF, distortionControl=DEFAULT)
elemType2 = mesh.ElemType(elemCode=C3D6T, elemLibrary=STANDARD)
elemType3 = mesh.ElemType(elemCode=C3D4T, elemLibrary=STANDARD)
pickedRegions=p.sets['AllCells']
p.setElementType(regions=pickedRegions, elemTypes=(elemType1, elemType2, 
    elemType3))
## ============================================== ##
##                      Material                  ##
## ============================================== ##
mdb.models[modelname].Material(name=materialname)
# define thermal properties
mdb.models[modelname].materials[materialname].Density(table=((rho, ), ))
mdb.models[modelname].materials[materialname].UserDefinedField()
mdb.models[modelname].materials[materialname].HeatGeneration()
mdb.models[modelname].materials[materialname].Depvar(n=ndepar)
mdb.models[modelname].materials[materialname].Conductivity(table=((k33, ), ))
#  User-defined fields may be activated by the *field or 
# *initial conditions,type=field options or 
# by defining materials with field variable dependencies
# mdb.models[modelname].materials[materialname].SpecificHeat(table=((Cp, ), ))
mdb.models[modelname].materials[materialname].SpecificHeat(dependencies=1, 
    table=((Cp_uncured, 0.0), (Cp_uncured, 0.88), (Cp_cured, 0.881), (Cp_cured, DoC_max)))
mdb.models[modelname].materials[materialname].UserMaterial()
mdb.models[modelname].materials[materialname].Expansion(type=ORTHOTROPIC, 
    userSubroutine=ON)
## ============================================== ##
##                      Section                   ##
## ============================================== ##
# create and assign section property
mdb.models[modelname].HomogeneousSolidSection(name='Section-1', 
    material=materialname, thickness=None)

for i1 in range(n_ply):
    layername = 'Layer-'+str(i1+1)
    region = p.sets[layername]
    p.SectionAssignment(region=region, sectionName='Section-1', offset=0.0, 
        offsetType=MIDDLE_SURFACE, offsetField='', 
        thicknessAssignment=FROM_SECTION)
## =============================================== ##
##                Fibre Orientation                ##
## =============================================== ##
# assign material orientation according to fibre-orient list
# NOTE: 1.If you define the normal axis by selecting a surface or face,
#         Abaqus/CAE finds the closest point on the surface or face and 
#         uses the surface normal at that point as the normal axis direction
#       2.If you define the primary axis by selecting an edge, 
#         Abaqus/CAE finds the closest point on the edge and 
#         uses the edge tangent at that point as the primary axis construction direction
#       3.Abaqus/CAE computes the secondary axis direction by taking the cross product
#         of the primary axis direction and the normal axis direction
# --------------------------------------------------
for i1 in range(n_ply):
    layername = 'Layer-'+str(i1+1)
    orient=list_orient[i1]
    print orient
    if orient==90:
        region = p.sets[layername]
        # define normal surface (axis-3, stacking direction)
        normalAxisRegion = p.surfaces['OuterSurf']
        # define primary axis (axis-1)
        primaryAxisRegion = p.sets['BotZEdge']
        # assign orientation 
        mdb.models[modelname].parts['Part-1'].MaterialOrientation(region=region, 
            orientationType=DISCRETE, axis=AXIS_1, normalAxisDefinition=SURFACE, 
            normalAxisRegion=normalAxisRegion, flipNormalDirection=False, 
            normalAxisDirection=AXIS_3, primaryAxisDefinition=EDGE, 
            primaryAxisRegion=primaryAxisRegion, primaryAxisDirection=AXIS_1, 
            flipPrimaryDirection=False, additionalRotationType=ROTATION_NONE, 
            angle=0.0, additionalRotationField='', stackDirection=STACK_3)
    elif orient==45:
        region = p.sets[layername]
        # define normal surface (axis-3, stacking direction)
        normalAxisRegion = p.surfaces['OuterSurf']
        # define primary axis (axis-1)
        primaryAxisRegion = p.sets['ArcEdge']
        # assign orientation 
        mdb.models[modelname].parts['Part-1'].MaterialOrientation(region=region, 
            orientationType=DISCRETE, axis=AXIS_3, normalAxisDefinition=SURFACE, 
            normalAxisRegion=normalAxisRegion, flipNormalDirection=False, 
            normalAxisDirection=AXIS_3, primaryAxisDefinition=EDGE, 
            primaryAxisRegion=primaryAxisRegion, primaryAxisDirection=AXIS_1, 
            flipPrimaryDirection=False, additionalRotationType=ROTATION_ANGLE, 
            additionalRotationField='', angle=-45.0, stackDirection=STACK_3)
    elif orient==-45:
        region = p.sets[layername]
        # define normal surface (axis-3, stacking direction)
        normalAxisRegion = p.surfaces['OuterSurf']
        # define primary axis (axis-1)
        primaryAxisRegion = p.sets['ArcEdge']
        # assign orientation 
        mdb.models[modelname].parts['Part-1'].MaterialOrientation(region=region, 
            orientationType=DISCRETE, axis=AXIS_3, normalAxisDefinition=SURFACE, 
            normalAxisRegion=normalAxisRegion, flipNormalDirection=False, 
            normalAxisDirection=AXIS_3, primaryAxisDefinition=EDGE, 
            primaryAxisRegion=primaryAxisRegion, primaryAxisDirection=AXIS_1, 
            flipPrimaryDirection=False, additionalRotationType=ROTATION_ANGLE, 
            additionalRotationField='', angle=45.0, stackDirection=STACK_3)
    elif orient==0:
        region = p.sets[layername]
        # define normal axis (axis-3, stacking direction)
        normalAxisRegion = p.surfaces['OuterSurf']
        # define primary axis (axis-1)
        primaryAxisRegion = p.sets['ArcEdge']
        # assign orientation 
        mdb.models[modelname].parts['Part-1'].MaterialOrientation(region=region, 
            orientationType=DISCRETE, axis=AXIS_1, normalAxisDefinition=SURFACE, 
            normalAxisRegion=normalAxisRegion, flipNormalDirection=False, 
            normalAxisDirection=AXIS_3, primaryAxisDefinition=EDGE, 
            primaryAxisRegion=primaryAxisRegion, primaryAxisDirection=AXIS_1, 
            flipPrimaryDirection=False, additionalRotationType=ROTATION_NONE, 
            angle=0.0, additionalRotationField='', stackDirection=STACK_3)
    else:
        print 'orientation not defined'

## ============================================== ##
##                   Assembly                     ##
## ============================================== ##
a = mdb.models[modelname].rootAssembly
a.Instance(name='Instance', part=p, dependent=ON)
## ============================================== ##
##                   Steps                        ##
## ============================================== ##
mdb.models[modelname].CoupledTempDisplacementStep(name='AutoclaveCure', 
    previous='Initial', timePeriod=totalPeriod, maxNumInc=totalPeriod*10, 
    initialInc=1.0, minInc=1e-05, maxInc=10.0, deltmx=100.0)
mdb.models[modelname].StaticStep(name='LoadRelease', previous='AutoclaveCure', 
    initialInc=1e-05)
# create field output
# mdb.models[modelname].fieldOutputRequests['F-Output-1'].setValues(variables=(
#     'S', 'E', 'EE', 'IE', 'THE', 'U', 'RF', 'NT', 'TEMP', 'SDV'))
mdb.models[modelname].fieldOutputRequests['F-Output-1'].setValues(variables=(
    'E', 'EE', 'IE', 'NT', 'S', 'SDV', 'TEMP', 'U'), frequency=5)
## ============================================== ##
##                  Thermal BCs                   ##
## ============================================== ##
# create room temperature (predefined fields)
a = mdb.models[modelname].rootAssembly
region = a.instances['Instance'].sets['AllCells']
mdb.models[modelname].Temperature(name='RoomTemp', createStepName='Initial', 
    region=region, distributionType=UNIFORM, 
    crossSectionDistribution=CONSTANT_THROUGH_THICKNESS, magnitudes=(predefined_temp, ))
# create table of temp cycle
mdb.models[modelname].TabularAmplitude(name='MRCC', timeSpan=STEP, 
    smooth=SOLVER_DEFAULT, data=MRCC)

# # create temperature BC at outer surface (tool)
# region = a.instances['Instance'].sets['OuterSurf']
# mdb.models[modelname].TemperatureBC(name='OuterTemp', 
#     createStepName='AutoclaveCure', region=region, fixed=OFF, 
#     distributionType=UNIFORM, fieldName='', magnitude=1.0, 
#     amplitude='MRCC')

# # create temperature BC at inner surface (vacuum film)
# region = a.instances['Instance'].sets['InnerSurf']
# mdb.models[modelname].TemperatureBC(name='InnerTemp', 
#     createStepName='AutoclaveCure', region=region, fixed=OFF, 
#     distributionType=UNIFORM, fieldName='', magnitude=1.0, 
#     amplitude='MRCC')

# create convective BC with surface film interaction
region=a.instances['Instance'].surfaces['OuterSurf']
mdb.models[modelname].FilmCondition(name='Int-toolside', 
    createStepName='AutoclaveCure', surface=region, definition=EMBEDDED_COEFF, 
    filmCoeff=57.48, filmCoeffAmplitude='', sinkTemperature=1.0, 
    sinkAmplitude='MRCC', sinkDistributionType=UNIFORM, sinkFieldName='')

region=a.instances['Instance'].surfaces['InnerSurf']
mdb.models[modelname].FilmCondition(name='Int-vacuumbag', 
    createStepName='AutoclaveCure', surface=region, definition=EMBEDDED_COEFF, 
    filmCoeff=137.3, filmCoeffAmplitude='', sinkTemperature=1.0, 
    sinkAmplitude='MRCC', sinkDistributionType=UNIFORM, sinkFieldName='')
## ============================================== ##
##                Mechanical BCs                  ##
## ============================================== ##
# create datum cylindrical csys --------------------
# NOTE: datum csys-cylindrical (1-R, 2-theta, 3-Z)
# NOTE: Origin (0,0,0); point on R (1,0,0); point on Rtheta (0,1,0)
# --------------------------------------------------
# localCsys: 1-axis: through-thickness direction
#            2-axis: fibre direction along radius
#            3-axis: perpendicular to principle axis (global z-axis)
# --------------------------------------------------
v = p.vertices
p.DatumCsysByThreePoints(name='CSYS-Cylindrical', coordSysType=CYLINDRICAL, 
    origin=(0.0, 0.0, 0.0), point1=(1.0, 0.0, 0.0), point2=(0.0, 1.0, 0.0))
CSYS_datumID = p.features['CSYS-Cylindrical'].id
datum = mdb.models[modelname].rootAssembly.instances['Instance'].datums[CSYS_datumID]
a = mdb.models[modelname].rootAssembly
a.regenerate()

# symmetry BC at the edge surfaces (U2=UR1=UR3=0, localCsys)
# symmetric about global Y-Z plane
for k in range(n_ply):
    set_name = 'PlyEdge-%s'%(k+1)
    BC_name = 'SymEdge-%s'%(k+1)
    region = a.instances['Instance'].sets[set_name]
    mdb.models[modelname].YsymmBC(name=BC_name, createStepName='Initial', 
        region=region, localCsys=datum)

# symmetry BC at the arch-side edge surfaces (U3=UR1=UR2=0, localCsys)
# symmetric about global X-Y plane
for k in range(n_ply):
    set_name = 'PlyArchEdge-%s'%(k+1)
    BC_name = 'SymArchEdge-%s'%(k+1)
    region = a.instances['Instance'].sets[set_name]
    mdb.models[modelname].ZsymmBC(name=BC_name, createStepName='Initial', 
        region=region, localCsys=datum)

# sliding BC at the outer surface (U1=0, localCsys)
region = a.instances['Instance'].sets['OuterSurf']
mdb.models[modelname].DisplacementBC(name='Sliding', 
    createStepName='AutoclaveCure', region=region, u1=0.0, u2=UNSET, u3=UNSET, 
    ur1=UNSET, ur2=UNSET, ur3=UNSET, amplitude=UNSET, fixed=OFF, 
    distributionType=UNIFORM, fieldName='', localCsys=datum)
mdb.models[modelname].boundaryConditions['Sliding'].deactivate('LoadRelease')

# pressure at the inner surface 
region = a.instances['Instance'].surfaces['InnerSurf']
mdb.models[modelname].Pressure(name='Pressure', createStepName='AutoclaveCure', 
    region=region, distributionType=UNIFORM, field='', magnitude=pressure, 
    amplitude=UNSET)
mdb.models[modelname].loads['Pressure'].deactivate('LoadRelease')

# to fixed the top edge from rigid displacement
region = a.instances['Instance'].sets['TopZEdge']
mdb.models[modelname].DisplacementBC(name='BC-Support', 
    createStepName='AutoclaveCure', region=region, u1=0.0, u2=UNSET, u3=UNSET, 
    ur1=UNSET, ur2=UNSET, ur3=UNSET, amplitude=UNSET, fixed=OFF, 
    distributionType=UNIFORM, fieldName='', localCsys=datum)
## ============================================== ##
##                       Job                      ##
## ============================================== ##
# mdb.Job(name=jobname, model=modelname, description='', type=ANALYSIS, 
#     atTime=None, waitMinutes=0, waitHours=0, queue=None, memory=90, 
#     memoryUnits=PERCENTAGE, getMemoryFromAnalysis=True, 
#     explicitPrecision=SINGLE, nodalOutputPrecision=SINGLE, echoPrint=OFF, 
#     modelPrint=OFF, contactPrint=OFF, historyPrint=OFF, 
#     userSubroutine=subroutine_path, 
#     scratch='', resultsFormat=ODB, multiprocessingMode=DEFAULT, numCpus=4, 
#     numDomains=4, numGPUs=0)
# mdb.jobs[jobname].writeInput(consistencyChecking=OFF)

mdb.Job(name=jobname, model=modelname, description='', type=ANALYSIS, 
    atTime=None, waitMinutes=0, waitHours=0, queue=None, memory=90, 
    memoryUnits=PERCENTAGE, getMemoryFromAnalysis=True, 
    explicitPrecision=SINGLE, nodalOutputPrecision=SINGLE, echoPrint=OFF, 
    modelPrint=OFF, contactPrint=OFF, historyPrint=OFF, 
    userSubroutine=subroutine_path, scratch='', 
    resultsFormat=ODB, multiprocessingMode=DEFAULT, numCpus=1, numGPUs=0)
# mdb.jobs[jobname].submit(consistencyChecking=OFF)

